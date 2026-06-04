import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/address/location_model.dart';
import 'package:project_shop/features/account/account_controller.dart';

class AddressController extends BaseController {
  final ApiService apiService = Get.find();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxList<LocationProvince> provinces = <LocationProvince>[].obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadLocations(), loadAddresses()]);
    } catch (error) {
      Get.snackbar('Dia chi', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLocations() async {
    if (provinces.isNotEmpty) return;

    final source =
        await rootBundle.loadString('assets/address/location-data.json');
    final decoded = jsonDecode(source) as List<dynamic>;
    provinces.assignAll(decoded
        .whereType<Map<String, dynamic>>()
        .map(LocationProvince.fromJson)
        .where((province) => province.name.isNotEmpty));
  }

  Future<void> loadAddresses() async {
    final response = await apiService.getAddresses();
    addresses.assignAll(response.data ?? []);
  }

  Future<bool> saveAddress({
    AddressModel? address,
    required Map<String, dynamic> body,
  }) async {
    isSaving.value = true;
    try {
      if (address?.id == null) {
        await apiService.createAddress(body);
      } else {
        await apiService.updateAddress(address!.id!, body);
      }

      await _refreshAfterMutation();
      return true;
    } catch (error) {
      Get.snackbar('Dia chi', _getErrorMessage(error));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> setDefault(AddressModel address) async {
    if (address.id == null) return false;
    if (address.isDefault) return true;

    try {
      await apiService.setDefaultAddress(address.id!);
      await _refreshAfterMutation();
      return true;
    } catch (error) {
      Get.snackbar('Dia chi', _getErrorMessage(error));
      return false;
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    if (address.id == null) return;
    if (address.isDefault) {
      Get.snackbar('Dia chi', 'Khong the xoa dia chi mac dinh.');
      return;
    }

    try {
      await apiService.deleteAddress(address.id!);
      await _refreshAfterMutation();
    } catch (error) {
      Get.snackbar('Dia chi', _getErrorMessage(error));
    }
  }

  Future<void> _refreshAfterMutation() async {
    await loadAddresses();
    if (Get.isRegistered<AccountController>()) {
      await Get.find<AccountController>().loadCurrentUser();
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
        }
        return data['message']?.toString() ?? 'Có lỗi xảy ra.';
      }
    }

    return 'Có lỗi xảy ra.';
  }
}
