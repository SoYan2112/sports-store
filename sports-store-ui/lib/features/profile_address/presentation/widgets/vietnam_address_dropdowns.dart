import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/vietnam_division_entity.dart';

class VietnamAddressDropdowns extends StatefulWidget {
  final List<VietnamProvince> provinces;
  final String? initialProvince;
  final String? initialDistrict;
  final String? initialWard;
  final void Function(String province, String district, String ward) onChanged;

  const VietnamAddressDropdowns({
    super.key,
    required this.provinces,
    this.initialProvince,
    this.initialDistrict,
    this.initialWard,
    required this.onChanged,
  });

  @override
  State<VietnamAddressDropdowns> createState() => _VietnamAddressDropdownsState();
}

class _VietnamAddressDropdownsState extends State<VietnamAddressDropdowns> {
  VietnamProvince? _selectedProvince;
  VietnamDistrict? _selectedDistrict;
  VietnamWard? _selectedWard;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  void _initValues() {
    if (widget.provinces.isEmpty) return;

    if (widget.initialProvince != null) {
      try {
        _selectedProvince = widget.provinces.firstWhere(
          (p) => p.name == widget.initialProvince,
        );
      } catch (_) {
        _selectedProvince = widget.provinces.first;
      }
    } else {
      _selectedProvince = widget.provinces.first;
    }

    if (_selectedProvince != null && _selectedProvince!.districts.isNotEmpty) {
      if (widget.initialDistrict != null) {
        try {
          _selectedDistrict = _selectedProvince!.districts.firstWhere(
            (d) => d.name == widget.initialDistrict,
          );
        } catch (_) {
          _selectedDistrict = _selectedProvince!.districts.first;
        }
      } else {
        _selectedDistrict = _selectedProvince!.districts.first;
      }
    }

    if (_selectedDistrict != null && _selectedDistrict!.wards.isNotEmpty) {
      if (widget.initialWard != null) {
        try {
          _selectedWard = _selectedDistrict!.wards.firstWhere(
            (w) => w.name == widget.initialWard,
          );
        } catch (_) {
          _selectedWard = _selectedDistrict!.wards.first;
        }
      } else {
        _selectedWard = _selectedDistrict!.wards.first;
      }
    }

    _notifyChange();
  }

  void _notifyChange() {
    widget.onChanged(
      _selectedProvince?.name ?? '',
      _selectedDistrict?.name ?? '',
      _selectedWard?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final districts = _selectedProvince?.districts ?? [];
    final wards = _selectedDistrict?.wards ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Cấp 1: Tỉnh / Thành phố
        _buildDropdownLabel('TỈNH / THÀNH PHỐ *'),
        _buildDropdownContainer(
          value: _selectedProvince,
          items: widget.provinces.map((prov) {
            return DropdownMenuItem<VietnamProvince>(
              value: prov,
              child: Text(
                prov.name,
                style: GoogleFonts.montserrat(color: AppColors.white),
              ),
            );
          }).toList(),
          onChanged: (newProv) {
            if (newProv != null) {
              setState(() {
                _selectedProvince = newProv;
                _selectedDistrict = newProv.districts.isNotEmpty ? newProv.districts.first : null;
                _selectedWard = _selectedDistrict != null && _selectedDistrict!.wards.isNotEmpty
                    ? _selectedDistrict!.wards.first
                    : null;
              });
              _notifyChange();
            }
          },
          hintText: 'Chọn Tỉnh / Thành phố',
        ),
        const SizedBox(height: 16),

        // Dropdown Cấp 2: Quận / Huyện
        _buildDropdownLabel('QUẬN / HUYỆN *'),
        _buildDropdownContainer(
          value: _selectedDistrict,
          items: districts.map((dist) {
            return DropdownMenuItem<VietnamDistrict>(
              value: dist,
              child: Text(
                dist.name,
                style: GoogleFonts.montserrat(color: AppColors.white),
              ),
            );
          }).toList(),
          onChanged: (newDist) {
            if (newDist != null) {
              setState(() {
                _selectedDistrict = newDist;
                _selectedWard = newDist.wards.isNotEmpty ? newDist.wards.first : null;
              });
              _notifyChange();
            }
          },
          hintText: 'Chọn Quận / Huyện',
        ),
        const SizedBox(height: 16),

        // Dropdown Cấp 3: Phường / Xã
        _buildDropdownLabel('PHƯỜNG / XÃ *'),
        _buildDropdownContainer(
          value: _selectedWard,
          items: wards.map((w) {
            return DropdownMenuItem<VietnamWard>(
              value: w,
              child: Text(
                w.name,
                style: GoogleFonts.montserrat(color: AppColors.white),
              ),
            );
          }).toList(),
          onChanged: (newWard) {
            if (newWard != null) {
              setState(() {
                _selectedWard = newWard;
              });
              _notifyChange();
            }
          },
          hintText: 'Chọn Phường / Xã',
        ),
      ],
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.oswald(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textGray,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDropdownContainer<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.textGray.withValues(alpha: 0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.darkSurface,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.white),
          hint: Text(
            hintText,
            style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 14),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
