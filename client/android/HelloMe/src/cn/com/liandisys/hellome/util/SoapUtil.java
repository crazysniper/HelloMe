package cn.com.liandisys.hellome.util;

import java.io.IOException;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.MarshalBase64;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.common.Const;

public class SoapUtil {
	
	private static String SOAP_ACTION = null;
	
	public static SoapObject buildSoapObject(String methodName) {
		SoapObject soapObject = new SoapObject(Const.NAMESPACE, methodName);
		SOAP_ACTION = methodName;
		return soapObject;
	}
	
	public static SoapObject setSoapRequestParamter(String[] paramters, SoapObject soapObject) {
		if (null == paramters) {
			return soapObject;
		} else if (paramters.length == 0) {
			return soapObject;
		}
		for (int i = 0; i < paramters.length; i++) {
			soapObject.addProperty("arg" + i, paramters[i]);
		}
		return soapObject;
	}
	
	public static SoapObject resultSoapObject(SoapObject soapObject) throws IOException, XmlPullParserException {
		System.setProperty("http.keepAlive", "false");
        HttpTransportSE ht = new HttpTransportSE(Const.URL);  
        ht.debug = true;  
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(  
                SoapEnvelope.VER11);
        envelope.dotNet = false;
        envelope.bodyOut = soapObject;
        new MarshalBase64().register(envelope);
        envelope.setOutputSoapObject(soapObject); 
        ht.call(Const.NAMESPACE + SOAP_ACTION, envelope);  
        if (envelope.getResponse() != null) {  
            SoapObject resultSoapObject = (SoapObject) envelope.bodyIn;  
            return resultSoapObject;  
        }  
        return null;  
    }
	
	public static String getResultString(SoapObject soapObject) throws IOException, XmlPullParserException{  
        SoapObject resultSoapObject = resultSoapObject(soapObject);  
        if (resultSoapObject != null) {
        	return String.valueOf(resultSoapObject.getProperty(0));  
        }
        return null;  
    }  
}
