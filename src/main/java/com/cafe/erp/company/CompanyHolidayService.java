package com.cafe.erp.company;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CompanyHolidayService {
	
	@Autowired
	private CompanyHolidayDAO companyHolidayDAO;

    @Value("${holiday.api.key}")
    private String holidayKey;

    public void apiHoliday(String year) {
        try {
            StringBuilder urlBuilder = new StringBuilder(
                    "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + this.holidayKey);
            urlBuilder.append("&" + URLEncoder.encode("solYear", "UTF-8") + "=" + year);
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=100");

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            // XML 파싱
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(conn.getInputStream());
            doc.getDocumentElement().normalize();

            NodeList nList = doc.getElementsByTagName("item");

            for (int i = 0; i < nList.getLength(); i++) {
                Node nNode = nList.item(i);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    String isHoliday = getTagValue("isHoliday", eElement);

                    if ("Y".equals(isHoliday)) {
                        String locdate = getTagValue("locdate", eElement); 
                        String dateName = getTagValue("dateName", eElement);

                        String dbDateStr = locdate.substring(0, 4) + "-" + locdate.substring(4, 6) + "-" + locdate.substring(6, 8);
                        
                        CompanyHolidayDTO dto = new CompanyHolidayDTO();
                        dto.setComHolidayDate(java.sql.Date.valueOf(dbDateStr));
                        dto.setComHolidayName(dateName);
                        dto.setComHolidayType("법정공휴일");
                        dto.setMemberId(999999); 
                        companyHolidayDAO.insertHoliday(dto);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // api텍스트 추출
    private static String getTagValue(String tag, Element eElement) {
        NodeList nlList = eElement.getElementsByTagName(tag);
        if (nlList.getLength() == 0) return null;
        NodeList childNodes = nlList.item(0).getChildNodes();
        if (childNodes.getLength() == 0) return null;
        Node nValue = childNodes.item(0);
        return nValue.getNodeValue();
    }

	public void addHoliday(CompanyHolidayDTO companyHolidayDTO) {
		
	}

	public List<CompanyHolidayDTO> selectHolidaysList() throws Exception{
		return companyHolidayDAO.selectHolidayList();
	}
}