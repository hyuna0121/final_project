package com.cafe.erp.vendor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VendorService {

	@Autowired
	private VendorDAO vendorDAO;
	
	@Transactional // 거래처코드생성로직
    public int generateVendorCode(String regionName) {
		
		if (regionName.equals("전북특별자치도") || regionName.equals("전남")) {
			regionName = "전라도";
		}
		
        // 1. 지역번호 (2자리)
        String regionCode = RegionCode.findCodeByAddress(regionName);

        // 2. 해당 지역의 최대 vendor_code 조회
        int maxCode = vendorDAO.selectMaxVendorCodeByRegion(regionCode);

        // 3. 뒤 4자리 추출
        int nextSeq;
        if (maxCode == 0) {
            nextSeq = 1;
        } else {
            nextSeq = maxCode % 10000 + 1;
        }

        // 4. 4자리 포맷 (0001)
        String seqStr = String.format("%04d", nextSeq);

        // 5. 최종 거래처 코드
        return Integer.parseInt(regionCode + seqStr);
    }
	
	public void add(VendorDTO vendorDTO) {
		// 거래처 코드 저장
		vendorDTO.setVendorCode(this.generateVendorCode(vendorDTO.getVendorAddress()));
		
		// 거래처 등록 담당자명 저장
		vendorDTO.setMemberId(119001);
		vendorDAO.add(vendorDTO);
	}
	
	public List<VendorDTO> findAll() {
		List<VendorDTO> list = vendorDAO.findAll();
		return list;
	}
	
	public void update(VendorDTO vendorDTO) {
		vendorDAO.update(vendorDTO);
	}
	
	public List<VendorDTO> search(VendorDTO vendorDTO){
		return vendorDAO.search(vendorDTO);
	}
	
}
