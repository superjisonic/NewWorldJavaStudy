import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.sinc.test.model.vo.TestDTO;

public class JsonMain {

	public static void main(String[] args) {
		//jsonObj();
		//jsonList();
		jsonMap();
	}
	public static void jsonMap() {
		TestDTO dto = new TestDTO("jssim","jssim");
		List<TestDTO> list = new ArrayList<TestDTO>();
		list.add(dto);list.add(dto);
		Map<String, List> map = new HashMap<>();
		map.put("list01", list); map.put("list02", list);
		JSONObject jMap = new JSONObject(map);
		System.out.println(jMap.toString());
	}
	
	public static void jsonList() {
		TestDTO dto = new TestDTO("jssim","jssim");
		List<TestDTO> list = new ArrayList<TestDTO>();
		list.add(dto);list.add(dto);
		JSONArray jAry = new JSONArray(list);
		System.out.println(jAry.toString());
	}
	public static void jsonObj() {
		TestDTO dto = new TestDTO("jssim","jssim");
		JSONObject jObj = new JSONObject(dto);
		System.out.println(jObj.toString());
	}


}
