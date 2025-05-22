import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';

class ListActionsButtons extends StatelessWidget {
  const ListActionsButtons({
    super.key,
    this.onDeletePressed,
    this.onEditPressed,
    this.onViewPressed,
    required this.includeDelete,
    required this.includeEdit,
    required this.includeView,
  }) : assert(includeDelete && onDeletePressed != null || includeDelete == false && onDeletePressed == null, 'If includeDelete is false, onDeletePressed must be null and vice versa'),
        assert(includeEdit && onEditPressed != null || includeEdit == false && onEditPressed == null, 'If includeEdit is false, onEditPressed must be null and vice versa'),
        assert(includeView && onViewPressed != null || includeView == false && onViewPressed == null, 'If includeView is false, onViewPressed must be null and vice versa');

  final VoidCallback? onDeletePressed;
  final VoidCallback? onViewPressed;
  final VoidCallback? onEditPressed;
  final bool includeDelete;
  final bool includeView;
  final bool includeEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        if(includeDelete) CustomMaterialButton(
          width: 25,
            borderRadius: BorderRadius.circular(8),
            onPressed: onDeletePressed!,
          buttonColor: primaryWhite,
          borderColor: errorRed,
          child: Icon(
            CupertinoIcons.delete,
            color: errorRed,
          ),
        ),
        if(includeEdit) CustomMaterialButton(
          width: 25,
            borderRadius: BorderRadius.circular(8),
            onPressed: onEditPressed!,
          buttonColor: primaryWhite,
          borderColor: primaryBlue,
          child: Icon(
            Icons.edit,
            color: primaryBlue,
          ),
        ),
        if(includeView) CustomMaterialButton(
          width: 25,
            borderRadius: BorderRadius.circular(8),
            onPressed: onViewPressed!,
          buttonColor: primaryWhite,
          borderColor: primaryBlue,
          child: Icon(
            CupertinoIcons.eye,
            color: primaryBlue,
          ),
        ),
      ],
    );
  }
}
