package cn.com.liandisys.hellome.server;

import javax.xml.ws.Endpoint;

import cn.com.liandisys.hellome.dao.HelloMeService;
import cn.com.liandisys.hellome.impl.HelloMeServiceImpl;

public class HelloMeServer {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		HelloMeService hms = new HelloMeServiceImpl();
        String address = "http://172.16.53.180/HelloMe";
        Endpoint.publish(address, hms);
	}

}
