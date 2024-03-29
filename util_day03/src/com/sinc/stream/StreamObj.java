package com.sinc.stream;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter; //이걸 쓰지 못하는 경우 FileOutputStream을 chaining (한글깨짐 방지)
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;

public class StreamObj {
	
	public void saveToFile() {
		File			file = null;//file관련된 정보를 다 알 수 있다. 이 객체로.... 파일경로라던지...
		FileWriter		writer = null;
		
		/*문자열을 파일로 저장하는 가장 보편적인 방법*/
		BufferedWriter	buffer = null;
		
		//////object stream 사용
		FileOutputStream	fos = null;
		ObjectOutputStream	oos = null;
		
		
		try {
			
			
			/*
			file = new File("text.txt");
			writer = new FileWriter(file);
			//여기서 실력을 더 향상시키고 싶다면
			buffer = new BufferedWriter(writer);//chaining! 쉽게보면 writer를 4차선, buffer를 8차선을 보면된다.
			buffer.write("테스트 입니다~~~");
			*/
			
			//객체를 입출력하고 싶다면 : objectoutput과 fileoutputStream을 써야함. stream자체는 직렬할 수 없음... 
			
			file = new File("obj.txt");
			fos = new FileOutputStream(file);
			oos = new ObjectOutputStream(fos);
			
			List<String> list = new ArrayList<>();
			list.add("jslim"); list.add("parksu");// 이 둘다 직렬화의 대상이 되고 이씀. 그리고 여기에 한글을 쓰면 깨져서 들어감. byteStream이니까			
			oos.writeObject(list);//객체가 반드시 serialized한 object를 writing하고 있어야 모든 객체를 다 보낼 수 있는 이 메서드 사용 가능
			
			
			//이 결과는 문자가 깨져서 나옴. 하지만 이걸 de-serialize하면 원문으로 바꿀 수 있음 FileInputStream 만든다.
		
			
			
			System.out.println("stream close");
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(buffer != null) {buffer.close();}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		
	}
	
	public void loadToFile() {
		FileInputStream fis = null;
		ObjectInputStream ois = null;
		
		try {
			fis = new FileInputStream("obj.txt");
			ois = new ObjectInputStream(fis);
			
			List<String> list = (List)(ois.readObject());
			System.out.println(list);
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			try{
				if(ois !=null) {
					ois.close();
					}
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}
	
}
