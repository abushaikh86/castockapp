import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_audit/db_handler.dart';
import 'package:stock_audit/models/adminusers.dart';
import 'package:stock_audit/util/constants.dart' as constants;

import '../../models/auditentriesmodel.dart';
import '../appbar.dart';
import '../jsondata/GetBrandData.dart';
import '../jsondata/GetCompanyData.dart';
import '../jsondata/GetDescriptionData.dart';
import '../jsondata/GetFormatData.dart';
import '../jsondata/GetVariantData.dart';
import '../jsondata/GetWarehouseData.dart';
import 'auditentries_handler.dart';

// ignore: must_be_immutable
class AddAuditEntries extends StatefulWidget {
  String selectedCompanyId;
  String auditId;
  AddAuditEntries({required this.selectedCompanyId, required this.auditId});
  State<AddAuditEntries> createState() => _AddAuditEntries(selectedCompanyId);
}

class _AddAuditEntries extends State<AddAuditEntries> {
  String selectedCompanyId;
  String? selectedMfgMonth;
  String? selectedMfgYear;
  String? selectedExpMonth;
  String? selectedExpYear;
  double existingActualUnits = 0;
  _AddAuditEntries(this.selectedCompanyId);

  var brandId = TextEditingController();
  var formatId = TextEditingController();
  var variantId = TextEditingController();
  var descriptionId = TextEditingController();
  var mfgMonth = TextEditingController();
  var mfgYear = TextEditingController();
  var expMonth = TextEditingController();
  var expYear = TextEditingController();
  var warehouseId = TextEditingController();
  var weight = TextEditingController();
  var mrp = TextEditingController();
  var valuationPerUnit = TextEditingController();
  var systemUnit = TextEditingController();
  var calculation = TextEditingController();
  var actualUnits = TextEditingController();
  var totalValuation = TextEditingController();
  var totalAmount = TextEditingController();

  List<GetCompanyData> _companyMasterList = [];
  List<AdminUsersModel> _adminUserList = [];
  List<GetBrandData> _brandMasterList = [];
  List<GetFormatData> _formatMasterList = [];
  List<GetVariantData> _variantMasterList = [];
  List<GetWarehouseData> _warehouseMasterList = [];
  List<GetDescriptionData> _descriptionMasterList = [];
  List<String> _calculationArr = [];
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> _years = [];
  int fromYear = 2000;
  int toYear = 2050;

  AuditentriesDBHelper? dbHelper;
  DBHelper? db;

  String selectedBrand = "";
  Map<String, String> brandData = {};
  String selectedFormat = "";
  Map<String, String> formatData = {};
  String selectedVariant = "";
  Map<String, String> variantData = {};
  String selectedWarehouse = "";
  Map<String, String> warehouseData = {};
  String selectedDescription = "";
  Map<String, String> descriptionData = {};
  Map<int, String> companyData = {};
  Map<int, String> adminUserData = {};

  void initState() {
    super.initState();
    dbHelper = AuditentriesDBHelper();
    db = DBHelper();
    getBrandData(selectedCompanyId);
    getWarehouseData(selectedCompanyId);
    getYears();
    getCompanyData();
    getAdminUserData();
  }

  void resetFields() {
    setState(() {
      selectedBrand = "";
      selectedFormat = "";
      selectedVariant = "";
      selectedDescription = "";
      selectedMfgMonth = "";
      selectedMfgYear = "";
      selectedExpMonth = "";
      selectedExpYear = "";
      selectedWarehouse = "";
      brandId.text = "";
      formatId.text = "";
      variantId.text = "";
      descriptionId.text = "";
      mfgMonth.text = "";
      mfgYear.text = "";
      expMonth.text = "";
      expYear.text = "";
      warehouseId.text = "";
      weight.text = "";
      mrp.text = "";
      valuationPerUnit.text = "";
      systemUnit.text = "";
      calculation.text = "";
      actualUnits.text = "";
      totalAmount.text = "";
      totalValuation.text = "";
      _calculationArr.clear();
    });
  }

  Future<void> getCompanyData() async {
    _companyMasterList = await db!.getCompanyListArray();
    for (int i = 0; i < _companyMasterList.length; i++) {
      companyData[_companyMasterList[i].companyId!] =
          _companyMasterList[i].companyName!;
    }
  }

  getCompanyName(companyId) {
    var companyName = "";
    if (companyId != '') {
      companyName = companyData[int.parse(companyId)].toString();
    }
    return companyName;
  }

  Future<void> getAdminUserData() async {
    _adminUserList = await db!.getAdminUsersList();
    for (int i = 0; i < _adminUserList.length; i++) {
      adminUserData[_adminUserList[i].adminUserId!] =
          _adminUserList[i].firstName!;
    }
  }

  getAdminUserName(adminUserId) {
    var adminUserName = "";
    if (adminUserId != '') {
      adminUserName = adminUserData[int.parse(adminUserId)].toString();
    }
    return adminUserName;
  }

  Future<void> getYears() async {
    for (int i = fromYear; i < toYear; i++) {
      _years.add(i.toString());
    }
  }

  Future<void> getBrandData(selectedCompanyId) async {
    _brandMasterList = await db!.getBrandListByCompany(selectedCompanyId);
    for (int i = 0; i < _brandMasterList.length; i++) {
      //_brandList.add(_brandMasterList[i].brandName!);
      brandData[_brandMasterList[i].brandId!.toString()] =
          _brandMasterList[i].brandName!;
    }
    setState(() {});
  }

  getBrandName(brandId) {
    var brandName = "";
    if (brandId != '') {
      brandName = brandData[brandId].toString();
    }
    // print(brandName);
    return brandName;
  }

  Future<void> getFormatDataByBrand(brandId) async {
    _formatMasterList = await db!.getFormatListByBrand(brandId);
    // print(_formatMasterList);
    for (int i = 0; i < _formatMasterList.length; i++) {
      //_formatList.add(_formatMasterList[i].formatName!);
      formatData[_formatMasterList[i].formatId!.toString()] =
          _formatMasterList[i].formatName!;
    }
    setState(() {});
  }

  getFormatName(formatId, brandId) {
    var formatName = "";
    if (formatId != '') {
      if (formatData.isEmpty) {
        getFormatDataByBrand(brandId)
            .whenComplete(() => formatName = formatData[formatId].toString());
      }
      formatName = formatData[formatId].toString();
    }
    //print(formatName);
    return formatName;
  }

  Future<void> getVariantDataByBrandAndFormat(brandId, formatId) async {
    _variantMasterList =
        await db!.getVariantListByBrandAndFormat(brandId, formatId);
    // print(companyId.text+" "+formatId);
    for (int i = 0; i < _variantMasterList.length; i++) {
      // _variantList.add(_variantMasterList[i].variantName!);
      variantData[_variantMasterList[i].variantId!.toString()] =
          _variantMasterList[i].variantName!;
    }
    setState(() {});
  }

  getVariantName(variantId, brandId, formatId) {
    var variantName = "";
    if (variantId != '') {
      if (variantData.isEmpty) {
        getVariantDataByBrandAndFormat(brandId, formatId)
            .then((value) => variantName = variantData[variantId].toString());
      }
      variantName = variantData[variantId].toString();
    }
    return variantName;
  }

  Future<void> getWarehouseData(selectedCompanyId) async {
    _warehouseMasterList =
        await db!.getWarehouseDataByCompany(selectedCompanyId);
    for (int i = 0; i < _warehouseMasterList.length; i++) {
      warehouseData[_warehouseMasterList[i].warehouseId!.toString()] =
          _warehouseMasterList[i].warehouseName!;
    }
    print(warehouseData);
    setState(() {});
  }

  getWarehouseName(warehouseId, companyId) {
    var warehouseName = "";
    if (warehouseId != '') {
      if (warehouseData.isEmpty) {
        getWarehouseData(companyId).then(
            (value) => warehouseName = warehouseData[warehouseId].toString());
      } else {
        warehouseName = warehouseData[warehouseId].toString();
      }
    }
    return warehouseName;
  }

  Future<void> getDescriptionData(brandId, formatId, variantId) async {
    _descriptionMasterList =
        await db!.getDescriptionListArray(brandId, formatId, variantId);
    //print(_descriptionMasterList);
    for (int i = 0; i < _descriptionMasterList.length; i++) {
      descriptionData[_descriptionMasterList[i].productId!.toString()] =
          _descriptionMasterList[i].productName!;
      // _descriptionList.add(_descriptionMasterList[i].productName!);
    }

    if (_descriptionMasterList.isNotEmpty) {
      // Fetch warehouse data and set the default value for the warehouse dropdown
      getWarehouseData(selectedCompanyId).then((value) {
        var defaultWarehouseId =
            _descriptionMasterList[0].warehouseId!.toString();
        setState(() {
          selectedWarehouse = warehouseData[defaultWarehouseId]!;
          warehouseId.text = defaultWarehouseId;
        });
      });
    }

    setState(() {});
  }

  getDescriptionName(productId, brandId, formatId, variantId) {
    var productName = "";
    if (productId != '') {
      if (descriptionData.isEmpty) {
        getDescriptionData(brandId, formatId, variantId).then(
            (value) => productName = descriptionData[productId].toString());
      }
      productName = descriptionData[productId].toString();
    }
    return productName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, 'Add Audit Entries', {'icons': Icons.menu}),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      //disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: brandData.values.toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Brand",
                        hintText: "Select Brand",
                      ),
                    ),
                    onChanged: (val) {
                      var key = brandData.keys.firstWhere(
                          (k) => brandData[k] == val!,
                          orElse: () => "");
                      setState(() {
                        selectedBrand = val!;
                        brandId.text = key;
                        formatData.clear();
                        variantData.clear();
                        descriptionData.clear();
                        getFormatDataByBrand(brandId.text);
                        selectedFormat = "";
                        selectedVariant = "";
                        selectedDescription = "";
                      });
                    },
                    selectedItem: selectedBrand,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      // disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: formatData.values.toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Format",
                        hintText: "Select Format",
                      ),
                    ),
                    onChanged: (val) {
                      var key = formatData.keys.firstWhere(
                          (k) => formatData[k] == val!,
                          orElse: () => "");

                      setState(() {
                        selectedFormat = val!;
                        formatId.text = key;
                        variantData.clear();
                        descriptionData.clear();
                        getVariantDataByBrandAndFormat(
                            brandId.text, formatId.text);
                        selectedVariant = "";
                        selectedDescription = "";
                      });
                    },
                    selectedItem: selectedFormat,
                  ),
                ),
              ],
            ),

            Container(height: 11),
            Row(
              children: [
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      //disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: variantData.values.toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Variant",
                        hintText: "Select Variant",
                      ),
                    ),
                    onChanged: (val) {
                      var key = variantData.keys.firstWhere(
                          (k) => variantData[k] == val!,
                          orElse: () => "");
                      setState(() {
                        selectedVariant = val!;
                        variantId.text = key;
                        descriptionData.clear();
                        getDescriptionData(
                            brandId.text, formatId.text, variantId.text);
                        selectedDescription = "";
                      });
                    },
                    selectedItem: selectedVariant,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      //disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: descriptionData.values.toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Select Description",
                      ),
                    ),
                    onChanged: (val) {
                      var key = descriptionData.keys.firstWhere(
                          (k) => descriptionData[k] == val!,
                          orElse: () => "");
                      setState(() {
                        selectedDescription = val!;
                        descriptionId.text = key;
                        db!
                            .getDescriptionRecord(brandId.text, formatId.text,
                                variantId.text, descriptionId.text)
                            .then((value) => value.forEach((element) {
                                  setState(() {
                                    selectedMfgMonth =
                                        element.mfgMonth.toString();
                                    selectedMfgYear =
                                        element.mfgYear.toString();
                                    selectedExpMonth =
                                        element.expMonth.toString();
                                    selectedExpYear =
                                        element.expYear.toString();
                                  });

                                  mrp.text = element.mrp.toString();
                                  weight.text = element.weight.toString();
                                  valuationPerUnit.text =
                                      element.valuationPerUnit.toString();
                                  systemUnit.text =
                                      element.systemUnit.toString();
                                  selectedWarehouse = getWarehouseName(
                                      element.warehouseId.toString(),
                                      element.companyId.toString());
                                  actualUnits.text = '0';
                                  totalAmount.text = '0';
                                  totalValuation.text =
                                      element.totalStockValue.toString();
                                }));
                        // var descriptionData = db.getDescription
                        // print(descriptionRecord);
                      });
                      // var descriptionData = db.getDescription
                    },
                    selectedItem: selectedDescription,
                  ),
                ),
              ],
            ),
            Container(height: 11),

            Container(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: _months,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "MFG Month",
                        hintText: "Select MFG Month",
                      ),
                    ),
                    onChanged: (val) {
                      mfgMonth.text = val!;
                    },
                    selectedItem: selectedMfgMonth,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: _years,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "MFG Year",
                        hintText: "Select MFG Year",
                      ),
                    ),
                    onChanged: (val) {
                      mfgYear.text = val!;
                    },
                    selectedItem: selectedMfgYear,
                  ),
                ),
              ],
            ),

            Container(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: _months,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "EXP Month",
                        hintText: "Select EXP Month",
                      ),
                    ),
                    onChanged: (val) {
                      expMonth.text = val!;
                    },
                    selectedItem: selectedExpMonth,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: _years,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "EXP Year",
                        hintText: "Select EXP Year",
                      ),
                    ),
                    onChanged: (val) {
                      expYear.text = val!;
                    },
                    selectedItem: selectedExpYear,
                  ),
                ),
              ],
            ),
            Container(height: 11),
            Row(
              children: [
                Flexible(
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                      //disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: warehouseData.values.toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Warehouse",
                        hintText: "Select Warehouse",
                      ),
                    ),
                    onChanged: (val) {
                      var key = warehouseData.keys.firstWhere(
                          (k) => warehouseData[k] == val!,
                          orElse: () => "");
                      setState(() {
                        selectedWarehouse = val!;
                        warehouseId.text = key;
                      });
                    },
                    selectedItem: selectedWarehouse,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(
                      controller: weight,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        //hintText: 'Enter Weight',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(11),
                        //     borderSide: BorderSide(
                        //       color: Colors.blue,
                        //     )
                        // ),
                        //prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      )),
                ),
              ],
            ),

            Container(height: 11),
            Row(
              children: [
                Flexible(
                  child: TextField(
                      controller: mrp,
                      decoration: InputDecoration(
                        labelText: 'MRP',
                        //hintText: 'Enter MRP',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(11),
                        //     borderSide: BorderSide(
                        //       color: Colors.blue,
                        //     )
                        // ),
                        //prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      )),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(
                      controller: valuationPerUnit,
                      decoration: InputDecoration(
                        labelText: 'Valuation Per Unit',
                        //hintText: 'Valuation Per Unit',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(11),
                        //     borderSide: BorderSide(
                        //       color: Colors.blue,
                        //     )
                        // ),
                        //prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      )),
                ),
              ],
            ),

            Container(height: 11),
            TextField(
                controller: systemUnit,
                decoration: InputDecoration(
                  labelText: 'System Unit',
                  //hintText: 'System Unit',
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(11),
                  //     borderSide: BorderSide(
                  //       color: Colors.blue,
                  //     )
                  // ),
                  //prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                )),
            Container(height: 11),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: calculation,
                    decoration: InputDecoration(
                      labelText: 'Calculation',
                      //hintText: 'Calculation',
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(11),
                      //     borderSide: BorderSide(
                      //       color: Colors.blue,
                      //     )
                      // ),
                      // prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton(
                      onPressed: () {
                        var calculations = calculation.text;
                        double calculationResult = 0;
                        if (calculations != '') {
                          Parser expression = Parser();
                          Expression calcActualUnit =
                              expression.parse(calculations);
                          ContextModel cm = ContextModel();
                          calculationResult =
                              calcActualUnit.evaluate(EvaluationType.REAL, cm);
                          print(json.encode(calculationResult));
                        }

                        if (actualUnits.text != '') {
                          existingActualUnits = double.parse(actualUnits.text);
                        }
                        print(existingActualUnits);
                        actualUnits.text =
                            (existingActualUnits + calculationResult)
                                .toString();
                        if (calculations != '') {
                          totalAmount.text = (double.parse(actualUnits.text) *
                                  double.parse(valuationPerUnit.text))
                              .round()
                              .toString();

                          _calculationArr.add(calculations);
                        }
                        print(_calculationArr);
                        calculation.text = "";
                      },
                      child: Text('Calculate')),
                ),
              ],
            ),
            Container(height: 11),
            Row(
              children: [
                Flexible(
                  child: TextField(
                      controller: actualUnits,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Actual Units',
                        //hintText: 'Actual Units',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(11),
                        //     borderSide: BorderSide(
                        //       color: Colors.blue,
                        //     )
                        // ),
                        // prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      )),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(
                      controller: totalAmount,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Total Valuation',
                        //hintText: 'Total Valuation',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(11),
                        //     borderSide: BorderSide(
                        //       color: Colors.blue,
                        //     )
                        // ),
                        // prefixIcon: Icon(Icons.list_alt, color: Colors.orange),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      )),
                ),
              ],
            ),

            // Container(height: 20),
            // DropdownButton(
            //     value: selectedItem, items: statusDropdown.map((e) {
            //   return DropdownMenuItem(value: e,child: Text(e));
            // }).toList(), onChanged: (val){
            //   setState(() {
            //     selectedItem = val as String;
            //   });
            // }),
            Container(height: 40),
            SizedBox(
              width: constants.buttonWidth,
              height: constants.buttonHeight,
              child: ElevatedButton(
                  onPressed: () async {
                    var sharedPref = await SharedPreferences.getInstance();

                    String uAuditId = widget.auditId;
                    String uBrand = brandId.text.toString();
                    String uFormat = formatId.text.toString();
                    String uVariant = variantId.text.toString();
                    String uDescription = descriptionId.text.toString();
                    String uWarehouse = warehouseId.text.toString();
                    String uWeight = weight.text.toString();
                    String uMrp = mrp.text.toString();
                    String uValuationPerUnit = valuationPerUnit.text.toString();
                    String uSystemUnit = systemUnit.text.toString();
                    String uCalculation = json.encode(_calculationArr);
                    String uActualUnit = actualUnits.text.toString();
                    String uTotalAmount = totalAmount.text.toString();
                    String uTotalValuation = totalValuation.text.toString();

                    dbHelper!
                        .insert(AuditEntriesModel(
                      auditId: uAuditId,
                      companyName: getCompanyName(selectedCompanyId),
                      userId: sharedPref.getString('user_id').toString(),
                      adminUserName:
                          getAdminUserName(sharedPref.getString('user_id')),
                      companyId: selectedCompanyId,
                      brandId: uBrand,
                      formatId: uFormat,
                      variantId: uVariant,
                      productId: uDescription,
                      mfgMonth: selectedMfgMonth,
                      mfgYear: selectedMfgYear,
                      expMonth: selectedExpMonth,
                      expYear: selectedExpYear,
                      warehouseId: uWarehouse,
                      weight: uWeight,
                      mrp: uMrp,
                      valuationPerUnit: uValuationPerUnit,
                      systemUnit: uSystemUnit,
                      calculationArr: uCalculation,
                      actualUnit: uActualUnit,
                      totalStockValue: uTotalValuation,
                      totalAmount: uTotalAmount,
                      productName: selectedDescription,
                      brandName: selectedBrand,
                      formatName: selectedFormat,
                      variantName: selectedVariant,
                      warehouseName: selectedWarehouse,
                    ))
                        .then((value) {
                      constants.Notification("Audit Entry Added Successfully");
                      resetFields();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => AuditEntries(auditCompanyId: selectedCompanyId.toString())));
                      //Navigator.pop(context,value);
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => AddAuditEntries(selectedCompanyId: selectedCompanyId.toString()),));
                    }).onError((error, stackTrace) {
                      print(error.toString());
                    });
                  },
                  child: Text('Save',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    primary: constants.mainColor, //background color of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)),
                  )),
            )
          ],
        )),
      ),
    );
  }
}
