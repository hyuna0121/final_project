package com.cafe.erp.vendor;

import java.util.Arrays;

public enum RegionCode {

	SEOUL("서울", "10"),
    GYEONGGI("경기도", "11"),
    CHUNGCHEONG("충청도", "12"),
    GANGWON("강원특별자치도", "13"),
    JEOLLA("전라도", "14"),
    GYEONGSANG("경상도", "15");

    private final String regionName;
    private final String code;

    RegionCode(String regionName, String code) {
        this.regionName = regionName;
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    public static String findCodeByAddress(String address) {
    	if (address == null || address.isBlank()) {
            throw new IllegalArgumentException("주소가 비어있음");
        }

        return Arrays.stream(values())
                .filter(r -> address.contains(r.regionName))
                .findFirst()
                .map(RegionCode::getCode)
                .orElseThrow(() -> new IllegalArgumentException("지역 매칭 실패: " + address));
    }
}
