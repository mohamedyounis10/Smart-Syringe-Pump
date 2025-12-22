import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class SalineMenuItem extends StatefulWidget {
  final String title;
  final String content;
  final bool showDropdown;
  final bool isExpanded;

  const SalineMenuItem({
    required this.title,
    required this.content,
    this.showDropdown = true,
    this.isExpanded = false,
  });

  @override
  _SalineMenuItemState createState() => _SalineMenuItemState();
}
class _SalineMenuItemState extends State<SalineMenuItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        children: [
          InkWell(
            onTap: widget.showDropdown
                ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
                : null,
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColor.text_color2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.showDropdown)
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColor.white,
                    ),
                ],
              ),
            ),
          ),
          if (_isExpanded && widget.content.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: AppColor.text_color1.withOpacity(0.4), // الأزرق الفاتح الشفاف
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.content,
                style: TextStyle(
                  color: AppColor.text_color2,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TopTabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TopTabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.text_color2 : AppColor.text_color1.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColor.white : AppColor.text_color2,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoScreenState extends State<InfoScreen> {
  int _selectedCategoryIndex = 1;

  final List<Widget> _salineItems = [
    SalineMenuItem(
      title: "Normal Saline (0.9% NaCl)",
      content: "An isotonic solution containing 0.9% sodium chloride. Commonly used for fluid and electrolyte replacement and for intravenous hydration.",
      isExpanded: true,
    ),
    SalineMenuItem(
      title: "Hypotonic Saline (0.45% NaCl)",
      content: "A hypotonic solution with half the sodium chloride concentration of normal saline. Used to treat mild cellular dehydration and provide free water.",
      isExpanded: false,
    ),
    SalineMenuItem(
      title: "Hypertonic Saline (3% NaCl)",
      content: "A hypertonic solution with a high concentration of sodium chloride. Used to treat severe hyponatremia or reduce cerebral edema.",
      isExpanded: false,
    ),
    SalineMenuItem(
      title: "Balanced Salt Solutions (BSS)",
      content: "Solutions containing electrolytes such as potassium, calcium, and magnesium. Commonly used in ophthalmic surgery to maintain tissue health.",
      isExpanded: false,
    ),
    SalineMenuItem(
      title: "Nasal Rinses/Sprays",
      content: "Saline solutions used for nasal irrigation to relieve congestion, moisturize nasal passages, and remove allergens or mucus.",
      isExpanded: false,
    ),
  ];

  final List<Widget> _aqueousItems = [
    SalineMenuItem(
      title: "Dextrose Solutions (D5W)",
      content: "An aqueous solution containing 5% dextrose (sugar). Used for hydration, providing calories, and as a carrier for medications.",
      isExpanded: true,
    ),
    SalineMenuItem(
      title: "Ringer's Lactate (LR)",
      content: "An isotonic solution containing sodium, chloride, potassium, calcium, and lactate. Used for fluid resuscitation and electrolyte replenishment.",
      isExpanded: false,
    ),
    SalineMenuItem(
      title: "Glucose-Electrolyte Solutions",
      content: "Solutions combining glucose and electrolytes to provide hydration, energy, and restore electrolyte balance. Often used in pediatric and adult fluid therapy.",
      isExpanded: false,
    ),
  ];

  List<Widget> _getCurrentList() {
    if (_selectedCategoryIndex == 0) {
      return _aqueousItems;
    } else {
      return _salineItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Row(
              children: [
                TopTabButton(
                  text: "Aqueous Solution",
                  isSelected: _selectedCategoryIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 0;
                    });
                  },
                ),
                SizedBox(width: 10.w),
                TopTabButton(
                  text: "Saline Solution",
                  isSelected: _selectedCategoryIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30.h),
            ..._getCurrentList(),
          ],
        ),
    );
  }
}
class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

