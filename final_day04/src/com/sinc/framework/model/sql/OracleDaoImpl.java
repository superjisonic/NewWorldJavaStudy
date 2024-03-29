package com.sinc.framework.model.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.sinc.oop.sub.model.vo.EmployeeVO;
import com.sinc.oop.sub.model.vo.StudentVO;
import com.sinc.oop.sub.model.vo.TeacherVO;

public class OracleDaoImpl implements Dao {
	
	/*
	 * dao는 데이터베이스에 대한 프로퍼티 정보를 필요로 한다.
	 * 
	 * 
	 * */
	
	/*상수선언*/
	
	public static final String DRIVER ="oracle.jdbc.driver.OracleDriver";//package이름 + 맨뒤에는 클래스 이름
	public static final String URL = "jdbc:oracle:thin:@127.0.0.1:1521:xe";//오라클 기본 포트이름은 1521임. xe는 디비의 sid
	public static final String USER= "hr";
	public static final String PASSWORD="hr";
	
	/*  *.jar 라는것이 바로 드라이버. ojdbc8.jar 여기에는 구현된 클래스들이 들어있는것이다.
	 * 디비연동을 하기 위해서는 먼저 이 드라이버를 메모리상에 올려야 이 안에 구현된 메소드를 실제로 사용할 수 있게된다.
	 * 인터페이스 메소드가 그제서야 구현이 가능해진다.
	 * 드라이버의 경로를 맨 위에 주어야함
	 * */
	
	//driver 로딩
	public OracleDaoImpl() {
		try {
			Class.forName(DRIVER);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	@Override
	public List<Object> selectRow() {
		System.out.println("dao selectRow");
		//Connection이라는 인터페이스!
		Connection 			conn = null;
		PreparedStatement	pstmt = null;
		//3.statement
		String selectSQL = "SELECT DIVISION, NAME, AGE, ADDRESS, COMM FROM TEST_OOP_TBL;";//insert시 sequence사용+각 물음표의 인덱스 12345
		ResultSet			rset = null;

		try {
			conn = DriverManager.getConnection(URL,USER,PASSWORD);
			pstmt = conn.prepareStatement(selectSQL);
			rset= pstmt.executeQuery();
			//List 는 반복문 밖에서 생성
			while(rset.next()) {
				int division = rset.getInt(1);
				if(division ==1) {
					StudentVO stu = new StudentVO(division,rset.getString(2),
							rset.getInt(3),rset.getString(4),rset.getString(5));
				}
				if(division ==2) {
					TeacherVO stu = new TeacherVO(division,rset.getString(2),
							rset.getInt(3),rset.getString(4),rset.getString(5));
				}
				if(division ==3) {
					EmployeeVO stu = new EmployeeVO(division,rset.getString(2),
							rset.getInt(3),rset.getString(4),rset.getString(5));
				}
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				if(conn != null) {conn.close();}//안정적인 코드는 아님. connection이 널일 수도 있기 때문 ... 그래서 null 조건을 추가해준다.
			}catch(Exception e) {
				e.printStackTrace();
			}
		}

		return null;//List를 리턴해야함 - 나중에 생성.... 이건 저스트어가이드라인. 현재 다른 클래스에서 void를 리턴하고 있기때문에 다 바꿔야함
	}

	@Override
	public Object selectPkRow() {
		System.out.println("dao selectPkRow");
		return null;
	}
	//2. connection관리
	@Override
	public int insertRow(Object obj) {
		System.out.println("dao insertRow");
		//Connection이라는 인터페이스!
		Connection 			conn = null;
		PreparedStatement	pstmt = null;
		//3.statement
		String insertSQL = "INSERT INTO TEST_OOP_TBL VALUES(OOP_SEQ.NEXTVAL,?,?,?,?,?)";//insert시 sequence사용+각 물음표의 인덱스 12345
		int flag = 0;
		try {
			conn = DriverManager.getConnection(URL,USER,PASSWORD);
			pstmt = conn.prepareStatement(insertSQL);
			
			//-----binding
			//근데 바인딩 전에 다운캐스팅이 필요함. 갖고오는게 obj이기 때문에....! instance of를 이용한다
			// alt+shift+a 다중선택
			if (obj instanceof StudentVO) {
				pstmt.setInt(1, ((StudentVO)obj).getDivision());
				pstmt.setString(2, ((StudentVO)obj).getName());
				pstmt.setInt(3, ((StudentVO)obj).getAge());
				pstmt.setString(4, ((StudentVO)obj).getAddress());
				pstmt.setString(5, ((StudentVO)obj).getStuID());
			}
			if (obj instanceof TeacherVO) {
				pstmt.setInt(1, ((TeacherVO)obj).getDivision());
				pstmt.setString(2, ((TeacherVO)obj).getName());
				pstmt.setInt(3, ((TeacherVO)obj).getAge());
				pstmt.setString(4, ((TeacherVO)obj).getAddress());
				pstmt.setString(5, ((TeacherVO)obj).getSubject());
			}
			if (obj instanceof EmployeeVO) {
				pstmt.setInt(1, ((EmployeeVO)obj).getDivision());
				pstmt.setString(2, ((EmployeeVO)obj).getName());
				pstmt.setInt(3, ((EmployeeVO)obj).getAge());
				pstmt.setString(4, ((EmployeeVO)obj).getAddress());
				pstmt.setString(5, ((EmployeeVO)obj).getDept());
			}
			
			//pstmt.setInt(5, obj.getXXXX());
			
			flag = pstmt.executeUpdate();//지역변수  4. execute
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				if(conn != null) {conn.close();}//안정적인 코드는 아님. connection이 널일 수도 있기 때문 ... 그래서 null 조건을 추가해준다.
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return flag;
	}

	@Override
	public int updateRow(Object obj) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteRow(Object obj) {
		return 0;
	}
	
}
