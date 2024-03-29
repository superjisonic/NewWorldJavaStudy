package com.sinc.framework.factory;

import java.util.HashMap;
import java.util.Map;

import com.sinc.framework.ctrl.Controller;
import com.sinc.framework.ctrl.InsertCtrl;
import com.sinc.framework.ctrl.PrintCtrl;

public class BeanFactory {
	private static BeanFactory instance;
	private Map<String, Controller> map;
	
	private BeanFactory() {
		map = new HashMap<>();
		map.put("insert", new InsertCtrl());
		map.put("print", new PrintCtrl());
		map.put("search", new InsertCtrl());
		map.put("delete", new PrintCtrl());
		
	}
	public static BeanFactory getInstance() {
		if(instance==null) {
			instance = new BeanFactory();
		}
		return instance;
	}
	public Controller getCtrl(String action) {
		return map.get(action);
	}
}
