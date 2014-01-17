package cn.com.liandisys.hellome.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import cn.com.liandisys.hellome.common.Const;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import android.media.ExifInterface;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;

public class FileUtil {

	private final static String TAG = "FileUtil";

	public static void savePicture(String fileName, String fileBuffer) {
		File filePath = Environment.getExternalStorageDirectory();
		if (!filePath.exists()) {
			filePath.mkdirs();
		}
		String fileFullName = filePath.getPath() + File.separator
				+ Const.PROJECT_DIRECTORYDIR + File.separator + fileName
				+ Const.JPG;
		Log.i(TAG, "fileFullName: " + fileFullName);
		File file = new File(fileFullName);
		if (!file.exists()) {
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdir();
			}
			FileOutputStream fos = null;
			try {
				file.createNewFile();
				fos = new FileOutputStream(file);
				byte b[] = Base64.decode(fileBuffer, Base64.DEFAULT);
				Bitmap bitmap = Bytes2Bimap(b);
				bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
				getSmallBitmap(fileFullName, 40, 40, 100);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (null != fos) {
						fos.flush();
						fos.close();
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static Bitmap getSmallBitmap(String filePath, int width, int height, int quality) {

		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(filePath, options);

		// Calculate inSampleSize
		options.inSampleSize = calculateInSampleSize(options, width, height);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;

		Bitmap bm = BitmapFactory.decodeFile(filePath, options);
		if (bm == null) {
			return null;
		}
		int degree = readPictureDegree(filePath);
		bm = rotateBitmap(bm, degree);
		FileOutputStream fosCom = null;
		try {
			File fileCom = new File(filePath.substring(0,
					filePath.lastIndexOf("."))
					+ Const.COMPRESS_NAME + Const.JPG);
			Log.i(TAG, "fileCom: " + fileCom.getPath());
			fosCom = new FileOutputStream(fileCom);
			bm.compress(Bitmap.CompressFormat.JPEG, quality, fosCom);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fosCom != null)
					fosCom.flush();
				fosCom.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return bm;
	}

	private static int readPictureDegree(String path) {
		int degree = 0;
		try {
			ExifInterface exifInterface = new ExifInterface(path);
			int orientation = exifInterface.getAttributeInt(
					ExifInterface.TAG_ORIENTATION,
					ExifInterface.ORIENTATION_NORMAL);
			switch (orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return degree;
	}

	private static Bitmap rotateBitmap(Bitmap bitmap, int rotate) {
		if (bitmap == null) {
			return null;
		}
		int w = bitmap.getWidth();
		int h = bitmap.getHeight();
		// Setting post rotate to 90
		Matrix mtx = new Matrix();
		mtx.postRotate(rotate);
		return Bitmap.createBitmap(bitmap, 0, 0, w, h, mtx, true);
	}

	private static int calculateInSampleSize(BitmapFactory.Options options,
			int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {
			// Calculate ratios of height and width to requested height and
			// width
			final int heightRatio = Math.round((float) height
					/ (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);

			// Choose the smallest ratio as inSampleSize value, this will
			// guarantee
			// a final image with both dimensions larger than or equal to the
			// requested height and width.
			inSampleSize = heightRatio < widthRatio ? widthRatio : heightRatio;
		}
		return inSampleSize;
	}

	public static byte[] Bitmap2Bytes(Bitmap bm) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		bm.compress(Bitmap.CompressFormat.PNG, 100, baos);
		return baos.toByteArray();
	}

	public static Bitmap Bytes2Bimap(byte[] b) {
		if (b.length != 0) {
			return BitmapFactory.decodeByteArray(b, 0, b.length);
		} else {
			return null;
		}
	}
}
