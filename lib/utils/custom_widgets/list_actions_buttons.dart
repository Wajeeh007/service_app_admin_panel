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
    this.deleteIcon,
    this.viewIcon,
    this.editIcon,
    this.deleteColor,
    this.viewColor,
    this.editColor,
  }) : assert(includeDelete && onDeletePressed != null || includeDelete == false && onDeletePressed == null && deleteIcon == null && deleteColor == null, 'If includeDelete is false, onDeletePressed, deleteIcon and deleteColor must be null'),
        assert(includeEdit && onEditPressed != null || includeEdit == false && onEditPressed == null && editIcon == null && editColor == null, 'If includeEdit is false, onEditPressed, editIcon and editColor must be null'),
        assert(includeView && onViewPressed != null || includeView == false && onViewPressed == null && viewIcon == null && viewColor == null, 'If includeView is false, onViewPressed, viewIcon and viewColor must be null');

  final VoidCallback? onDeletePressed;
  final VoidCallback? onViewPressed;
  final VoidCallback? onEditPressed;
  final bool includeDelete;
  final bool includeView;
  final bool includeEdit;
  final IconData? deleteIcon;
  final IconData? viewIcon;
  final IconData? editIcon;
  final Color? deleteColor;
  final Color? viewColor;
  final Color? editColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        if(includeDelete) CustomMaterialButton(
          width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(8),
            onPressed: onDeletePressed!,
          buttonColor: primaryWhite,
          borderColor: errorRed,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              deleteIcon ?? CupertinoIcons.delete,
              color: deleteColor ?? errorRed,
              size: 20,
            ),
          ),
        ),
        if(includeEdit) CustomMaterialButton(
          width: 20,
          height: 20,
            borderRadius: BorderRadius.circular(8),
            onPressed: onEditPressed!,
          buttonColor: primaryWhite,
          borderColor: primaryBlue,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              editIcon ?? Icons.edit,
              color: editColor ?? primaryBlue,
              size: 20,
            ),
          ),
        ),
        if(includeView) CustomMaterialButton(
          width: 20,
          height: 20,
            borderRadius: BorderRadius.circular(8),
            onPressed: onViewPressed!,
          buttonColor: primaryWhite,
          borderColor: primaryBlue,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              viewIcon ?? CupertinoIcons.eye,
              color: viewColor ?? primaryBlue,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
