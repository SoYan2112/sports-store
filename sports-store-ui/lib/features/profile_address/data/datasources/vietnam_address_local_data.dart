import '../models/vietnam_division_model.dart';

class VietnamAddressLocalData {
  static List<VietnamProvinceModel> getProvinces() {
    return [
      VietnamProvinceModel(
        id: 'HN',
        name: 'Hà Nội',
        districts: [
          VietnamDistrictModel(
            id: 'HN_BD',
            name: 'Ba Đình',
            wards: [
              VietnamWardModel(id: 'HN_BD_01', name: 'Phường Phúc Xá'),
              VietnamWardModel(id: 'HN_BD_02', name: 'Phường Trúc Bạch'),
              VietnamWardModel(id: 'HN_BD_03', name: 'Phường Kim Mã'),
              VietnamWardModel(id: 'HN_BD_04', name: 'Phường Liễu Giai'),
              VietnamWardModel(id: 'HN_BD_05', name: 'Phường Cống Vị'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HN_HK',
            name: 'Hoàn Kiếm',
            wards: [
              VietnamWardModel(id: 'HN_HK_01', name: 'Phường Hàng Bạc'),
              VietnamWardModel(id: 'HN_HK_02', name: 'Phường Hàng Đào'),
              VietnamWardModel(id: 'HN_HK_03', name: 'Phường Tràng Tiền'),
              VietnamWardModel(id: 'HN_HK_04', name: 'Phường Lý Thái Tổ'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HN_CG',
            name: 'Cầu Giấy',
            wards: [
              VietnamWardModel(id: 'HN_CG_01', name: 'Phường Dịch Vọng'),
              VietnamWardModel(id: 'HN_CG_02', name: 'Phường Dịch Vọng Hậu'),
              VietnamWardModel(id: 'HN_CG_03', name: 'Phường Quan Hoa'),
              VietnamWardModel(id: 'HN_CG_04', name: 'Phường Yên Hòa'),
              VietnamWardModel(id: 'HN_CG_05', name: 'Phường Trung Hòa'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HN_DD',
            name: 'Đống Đa',
            wards: [
              VietnamWardModel(id: 'HN_DD_01', name: 'Phường Cát Linh'),
              VietnamWardModel(id: 'HN_DD_02', name: 'Phường Láng Hạ'),
              VietnamWardModel(id: 'HN_DD_03', name: 'Phường Láng Thượng'),
              VietnamWardModel(id: 'HN_DD_04', name: 'Phường Ô Chợ Dừa'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HN_HBT',
            name: 'Hai Bà Trưng',
            wards: [
              VietnamWardModel(id: 'HN_HBT_01', name: 'Phường Bạch Mai'),
              VietnamWardModel(id: 'HN_HBT_02', name: 'Phường Bách Khoa'),
              VietnamWardModel(id: 'HN_HBT_03', name: 'Phường Đồng Tâm'),
              VietnamWardModel(id: 'HN_HBT_04', name: 'Phường Minh Khai'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HN_NTL',
            name: 'Nam Từ Liêm',
            wards: [
              VietnamWardModel(id: 'HN_NTL_01', name: 'Phường Mỹ Đình 1'),
              VietnamWardModel(id: 'HN_NTL_02', name: 'Phường Mỹ Đình 2'),
              VietnamWardModel(id: 'HN_NTL_03', name: 'Phường Mễ Trì'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'HCM',
        name: 'Hồ Chí Minh',
        districts: [
          VietnamDistrictModel(
            id: 'HCM_Q1',
            name: 'Quận 1',
            wards: [
              VietnamWardModel(id: 'HCM_Q1_01', name: 'Phường Bến Nghé'),
              VietnamWardModel(id: 'HCM_Q1_02', name: 'Phường Bến Thành'),
              VietnamWardModel(id: 'HCM_Q1_03', name: 'Phường Đa Kao'),
              VietnamWardModel(id: 'HCM_Q1_04', name: 'Phường Tân Định'),
              VietnamWardModel(id: 'HCM_Q1_05', name: 'Phường Phạm Ngũ Lão'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HCM_Q3',
            name: 'Quận 3',
            wards: [
              VietnamWardModel(id: 'HCM_Q3_01', name: 'Phường Võ Thị Sáu'),
              VietnamWardModel(id: 'HCM_Q3_02', name: 'Phường 1'),
              VietnamWardModel(id: 'HCM_Q3_03', name: 'Phường 2'),
              VietnamWardModel(id: 'HCM_Q3_04', name: 'Phường 3'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HCM_Q7',
            name: 'Quận 7',
            wards: [
              VietnamWardModel(id: 'HCM_Q7_01', name: 'Phường Tân Phong'),
              VietnamWardModel(id: 'HCM_Q7_02', name: 'Phường Tân Phú'),
              VietnamWardModel(id: 'HCM_Q7_03', name: 'Phường Phú Mỹ'),
              VietnamWardModel(id: 'HCM_Q7_04', name: 'Phường Tân Quy'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HCM_BT',
            name: 'Quận Bình Thạnh',
            wards: [
              VietnamWardModel(id: 'HCM_BT_01', name: 'Phường 19'),
              VietnamWardModel(id: 'HCM_BT_02', name: 'Phường 22'),
              VietnamWardModel(id: 'HCM_BT_03', name: 'Phường 25'),
              VietnamWardModel(id: 'HCM_BT_04', name: 'Phường 26'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HCM_TD',
            name: 'TP. Thủ Đức',
            wards: [
              VietnamWardModel(id: 'HCM_TD_01', name: 'Phường Thảo Điền'),
              VietnamWardModel(id: 'HCM_TD_02', name: 'Phường An Phú'),
              VietnamWardModel(id: 'HCM_TD_03', name: 'Phường Hiệp Phú'),
              VietnamWardModel(id: 'HCM_TD_04', name: 'Phường Linh Trung'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HCM_PN',
            name: 'Quận Phú Nhuận',
            wards: [
              VietnamWardModel(id: 'HCM_PN_01', name: 'Phường 1'),
              VietnamWardModel(id: 'HCM_PN_02', name: 'Phường 2'),
              VietnamWardModel(id: 'HCM_PN_03', name: 'Phường 9'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'DN',
        name: 'Đà Nẵng',
        districts: [
          VietnamDistrictModel(
            id: 'DN_HC',
            name: 'Quận Hải Châu',
            wards: [
              VietnamWardModel(id: 'DN_HC_01', name: 'Phường Hải Châu 1'),
              VietnamWardModel(id: 'DN_HC_02', name: 'Phường Hải Châu 2'),
              VietnamWardModel(id: 'DN_HC_03', name: 'Phường Thạch Thang'),
              VietnamWardModel(id: 'DN_HC_04', name: 'Phường Thuận Phước'),
            ],
          ),
          VietnamDistrictModel(
            id: 'DN_ST',
            name: 'Quận Sơn Trà',
            wards: [
              VietnamWardModel(id: 'DN_ST_01', name: 'Phường An Hải Bắc'),
              VietnamWardModel(id: 'DN_ST_02', name: 'Phường An Hải Tây'),
              VietnamWardModel(id: 'DN_ST_03', name: 'Phường Phước Mỹ'),
            ],
          ),
          VietnamDistrictModel(
            id: 'DN_TK',
            name: 'Quận Thanh Khê',
            wards: [
              VietnamWardModel(id: 'DN_TK_01', name: 'Phường Vĩnh Trung'),
              VietnamWardModel(id: 'DN_TK_02', name: 'Phường Tam Thuận'),
              VietnamWardModel(id: 'DN_TK_03', name: 'Phường Tân Chính'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'HP',
        name: 'Hải Phòng',
        districts: [
          VietnamDistrictModel(
            id: 'HP_HB',
            name: 'Quận Hồng Bàng',
            wards: [
              VietnamWardModel(id: 'HP_HB_01', name: 'Phường Hoàng Văn Thụ'),
              VietnamWardModel(id: 'HP_HB_02', name: 'Phường Minh Khai'),
              VietnamWardModel(id: 'HP_HB_03', name: 'Phường Phan Bội Châu'),
            ],
          ),
          VietnamDistrictModel(
            id: 'HP_NQ',
            name: 'Quận Ngô Quyền',
            wards: [
              VietnamWardModel(id: 'HP_NQ_01', name: 'Phường Cầu Đất'),
              VietnamWardModel(id: 'HP_NQ_02', name: 'Phường Lạch Tray'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'CT',
        name: 'Cần Thơ',
        districts: [
          VietnamDistrictModel(
            id: 'CT_NK',
            name: 'Quận Ninh Kiều',
            wards: [
              VietnamWardModel(id: 'CT_NK_01', name: 'Phường An Cư'),
              VietnamWardModel(id: 'CT_NK_02', name: 'Phường An Hòa'),
              VietnamWardModel(id: 'CT_NK_03', name: 'Phường Tân An'),
            ],
          ),
          VietnamDistrictModel(
            id: 'CT_CR',
            name: 'Quận Cái Răng',
            wards: [
              VietnamWardModel(id: 'CT_CR_01', name: 'Phường Lê Bình'),
              VietnamWardModel(id: 'CT_CR_02', name: 'Phường Hưng Phú'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'BD',
        name: 'Bình Dương',
        districts: [
          VietnamDistrictModel(
            id: 'BD_TDM',
            name: 'TP. Thủ Dầu Một',
            wards: [
              VietnamWardModel(id: 'BD_TDM_01', name: 'Phường Phú Cường'),
              VietnamWardModel(id: 'BD_TDM_02', name: 'Phường Phú Hòa'),
              VietnamWardModel(id: 'BD_TDM_03', name: 'Phường Định Hòa'),
            ],
          ),
          VietnamDistrictModel(
            id: 'BD_DA',
            name: 'TP. Dĩ An',
            wards: [
              VietnamWardModel(id: 'BD_DA_01', name: 'Phường Dĩ An'),
              VietnamWardModel(id: 'BD_DA_02', name: 'Phường Tân Đông Hiệp'),
            ],
          ),
        ],
      ),
      VietnamProvinceModel(
        id: 'DN_PROV',
        name: 'Đồng Nai',
        districts: [
          VietnamDistrictModel(
            id: 'DN_BH',
            name: 'TP. Biên Hòa',
            wards: [
              VietnamWardModel(id: 'DN_BH_01', name: 'Phường Trảng Dài'),
              VietnamWardModel(id: 'DN_BH_02', name: 'Phường Tân Phong'),
              VietnamWardModel(id: 'DN_BH_03', name: 'Phường Quyết Thắng'),
            ],
          ),
        ],
      ),
    ];
  }
}
