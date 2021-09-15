package com.example.mlkitexample;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;

import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.PoseDetector;
import com.google.mlkit.vision.pose.PoseLandmark;
import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions;

import java.util.concurrent.ExecutionException;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.media.Image;
import android.os.Bundle;
import android.os.Build;
import android.os.Handler;
import android.util.Size;
import android.widget.ImageView;
import android.content.pm.PackageManager;
import android.Manifest;
import android.content.Intent;

//import androidx.activity.result.ActivityResultCallback;
//import androidx.activity.result.ActivityResultLauncher;
//import androidx.activity.result.contract.ActivityResultContracts;


public class MainActivity extends FlutterActivity {

    private static final int CAMERA_REQUEST = 1888, READ_IMAGE_REQUEST = 1887, EXTERNAL_STORAGE_CODE=10009;
    private static final int MY_CAMERA_PERMISSION_CODE = 100;

    private static final String CHANNEL = "samples.flutter.dev/pose";
    MethodChannel channel;

    ImageAnalysis imageAnalysis;
    ListenableFuture cameraProviderFuture;
    public static CameraSelector lens = CameraSelector.DEFAULT_FRONT_CAMERA;
    boolean isFront = true;
    PoseDetector poseDetector;
    PoseLandmark leftShoulder, nose;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        askPermissions();
        PoseDetectorOptions options =
                new PoseDetectorOptions.Builder()
                        .setDetectorMode(PoseDetectorOptions.STREAM_MODE)
                        .build();
        poseDetector = PoseDetection.getClient(options);
    }

    void startAnalyzer(ProcessCameraProvider cameraProvider) {
        cameraProvider.unbindAll();
        CameraSelector cameraSelector = null;
        if(isFront) {
            cameraSelector = new CameraSelector.Builder().requireLensFacing(CameraSelector.LENS_FACING_FRONT).build();
        } else {
            cameraSelector = new CameraSelector.Builder().requireLensFacing(CameraSelector.LENS_FACING_BACK).build();
        }
        Preview preview = new Preview.Builder().build();

        imageAnalysis =
                new ImageAnalysis.Builder()
                        .setTargetResolution(new Size(768, 1024)) //// 1024, 768
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .build();
        System.out.println("STARTING IMAGE ANALYZER.....");
        imageAnalysis.setAnalyzer(ContextCompat.getMainExecutor(this), new ImageAnalysis.Analyzer() {
            @Override
            public void analyze(@NonNull ImageProxy imageProxy) {
                Image mediaImage = imageProxy.getImage();

                if (mediaImage != null) {
                    InputImage image =
                            InputImage.fromMediaImage(mediaImage, imageProxy.getImageInfo().getRotationDegrees());
                    // Process image
//                    System.out.println("RUNNING INFERENCE.....");
                    Task<Pose> result =
                            poseDetector.process(image)
                                    .addOnSuccessListener(
                                            new OnSuccessListener<Pose>() {
                                                @Override
                                                public void onSuccess(Pose pose) {
//                                                    List<PoseLandmark> allPoseLandmarks = pose.getAllPoseLandmarks();
//                                                    Bitmap btmp = PoseUtils.imageToBitmap(imageProxy.getImage(), imageProxy.getImageInfo().getRotationDegrees());
                                                    leftShoulder = pose.getPoseLandmark(PoseLandmark.LEFT_SHOULDER);
                                                    nose = pose.getPoseLandmark(PoseLandmark.NOSE);

                                                    if(leftShoulder != null) {
                                                        // System.out.println(leftShoulder.getPosition3D().getX() + " " + leftShoulder.getPosition3D().getY());
                                                    }
                                                    if(nose != null) {
                                                        // System.out.println(nose.getPosition3D().getX() + " " + nose.getPosition3D().getY());
                                                        channel.invokeMethod("nose", nose.getPosition3D().getX() + " " + nose.getPosition3D().getY()  + " " + nose.getPosition3D().getZ(),  new MethodChannel.Result() {
                                                            @Override
                                                            public void success(Object o) {
                                                                // System.out.println("SUCCESS OUTPUT: " + o.toString());
                                                            }
                                                          
                                                            @Override
                                                            public void error(String s, String s1, Object o) {
                                                                // System.out.println("ERROR OUTPUT: " + o.toString());
                                                            }
                                                          
                                                            @Override
                                                            public void notImplemented() {
                                                                // System.out.println("NOT IMPLEMENTED ");
                                                            }
                                                          });
                                                    }
                                                    imageProxy.close();
                                                }
                                            })
                                    .addOnFailureListener(
                                            new OnFailureListener() {
                                                @Override
                                                public void onFailure(@NonNull Exception e) {
                                                    imageProxy.close();
                                                }
                                            });

                }
            }
        });
        cameraProvider.bindToLifecycle((LifecycleOwner) this, cameraSelector, imageAnalysis);
    }

    @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
    channel.setMethodCallHandler(
          (call, result) -> {
              System.out.println(call.method);
              if(call.method.equals("GET_FACE")) {
                  if(nose != null) result.success(nose.getPosition3D().getX() + " " + nose.getPosition3D().getY());
              }
          }
        );
  }

    void askPermissions() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            System.out.println("====?> Asking....");
            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_CAMERA_PERMISSION_CODE);
            } else {
                cameraProviderFuture = ProcessCameraProvider.getInstance(this);
                cameraProviderFuture.addListener(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            ProcessCameraProvider cameraProvider = (ProcessCameraProvider) cameraProviderFuture.get();
                            startAnalyzer(cameraProvider);
                        } catch (ExecutionException | InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }, ContextCompat.getMainExecutor(this));
            }

            if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, EXTERNAL_STORAGE_CODE);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults)
    {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == MY_CAMERA_PERMISSION_CODE)
        {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED)
            {
                cameraProviderFuture = ProcessCameraProvider.getInstance(this);
                cameraProviderFuture.addListener(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            ProcessCameraProvider cameraProvider = (ProcessCameraProvider) cameraProviderFuture.get();
                            startAnalyzer(cameraProvider);
                        } catch (ExecutionException | InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }, ContextCompat.getMainExecutor(this));
            }
            else
            {
//                Toast.makeText(this, "camera permission denied", Toast.LENGTH_LONG).show();

            }
        }
        if(EXTERNAL_STORAGE_CODE == requestCode) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                System.out.println("Permission Granted");
            }
        }
    }
}
