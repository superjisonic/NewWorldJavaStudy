package com.sinc.framework.front.ctrl;

import java.util.List;

import com.sinc.framework.ctrl.Controller;
import com.sinc.framework.factory.BeanFactory;
import com.sinc.oop.sup.model.vo.PersonVO;

public class FrontCtrl {
	
	public List<PersonVO> requestProc(String action) {
		BeanFactory factory = BeanFactory.getInstance();
		Controller ctrl = factory.getCtrl(action);//getCtrl에 매핑되는 키값(insert,select....)를 넘겨준다.
		return ctrl.execute();
		
	}
	
	public void requestProc(String action, PersonVO per) {
		BeanFactory factory = BeanFactory.getInstance();
		Controller ctrl = factory.getCtrl(action);//getCtrl에 매핑되는 키값(insert,select....)를 넘겨준다.
		ctrl.execute(per);
	}
}
