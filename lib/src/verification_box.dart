library flutter_verification_box;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_box_item.dart';

typedef OnSubmitted = void Function(String text, Function? clear);

/// 验证码输入框
class VerificationBox extends StatefulWidget {
  const VerificationBox(
    this.ctrl, {
    Key? key,
    this.count = 6,
    this.itemWidth = 45,
    this.onSubmitted,
    this.type = VerificationBoxItemType.box,
    this.decoration,
    this.padding = 8.0,
    this.borderWidth = 2.0,
    this.borderRadius = 5.0,
    this.textStyle,
    this.focusBorderColor,
    this.borderColor,
    this.unfocus = true,
    this.autoFocus = true,
    this.showCursor = false,
    this.cursorWidth = 2,
    this.cursorColor,
    this.cursorPosition,
    this.cursorIndent = 10,
    this.cursorEndIndent = 10,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController ctrl;
  final double padding;

  /// 几位验证码，一般6位，还有4位的
  final int count;

  /// 每一个item的宽
  final double itemWidth;

  /// 输入完成回调
  final OnSubmitted? onSubmitted;

  /// 输入内容回调
  final ValueChanged? onChanged;

  /// 每个item的装饰类型，[VerificationBoxItemType]
  final VerificationBoxItemType type;

  /// 每个item的样式
  final Decoration? decoration;

  /// 边框宽度
  final double borderWidth;

  /// 边框颜色
  final Color? borderColor;

  /// 获取焦点边框的颜色
  final Color? focusBorderColor;

  /// [VerificationBoxItemType.box] 边框圆角
  final double borderRadius;

  /// 文本样式
  final TextStyle? textStyle;

  /// 输入完成后是否失去焦点，默认true，失去焦点后，软键盘消失
  final bool unfocus;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 是否显示光标
  final bool showCursor;

  /// 光标颜色
  final Color? cursorColor;

  /// 光标位置
  final CursorPosition? cursorPosition;

  /// 光标宽度
  final double cursorWidth;

  /// 光标距离顶部距离
  final double cursorIndent;

  /// 光标距离底部距离
  final double cursorEndIndent;

  @override
  State<StatefulWidget> createState() => _VerificationBox();
}

class _VerificationBox extends State<VerificationBox> {
  late Function clear;

  late FocusNode _focusNode;

  final List _contentList = [];

  @override
  void initState() {
    List.generate(widget.count, (index) {
      _contentList.add('');
    });

    clear = () {
      for (int i = 0; i < widget.count; i++) {
        _contentList[i] = '';
      }
      widget.ctrl.text = '';
      setState(() {});
    };
    var value = widget.ctrl.text;
    for (int i = 0; i < widget.count; i++) {
      if (i < value.length) {
        _contentList[i] = value.substring(i, i + 1);
      } else {
        _contentList[i] = '';
      }
    }

    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: [
          Positioned.fill(
            top: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.count, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.padding),
                  child: SizedBox(
                    width: widget.itemWidth,
                    height: widget.itemWidth + widget.padding * 2,
                    child: VerificationBoxItem(
                      itemWidth: widget.itemWidth,
                      data: _contentList[index],
                      textStyle: widget.textStyle,
                      type: widget.type,
                      decoration: widget.decoration,
                      borderRadius: widget.borderRadius,
                      borderWidth: widget.borderWidth,
                      borderColor: (widget.ctrl.text.length == index ||
                                  (widget.ctrl.text.length >= widget.count && index == (widget.count - 1))
                              ? widget.focusBorderColor
                              : widget.borderColor) ??
                          widget.borderColor,
                      showCursor: widget.showCursor && widget.ctrl.text.length == index,
                      cursorColor: widget.cursorColor,
                      cursorWidth: widget.cursorWidth,
                      cursorIndent: widget.cursorIndent,
                      cursorEndIndent: widget.cursorEndIndent,
                    ),
                  ),
                );
              }),
            ),
          ),
          _buildTextField(),
        ],
      ),
    );
  }

  /// 构建TextField
  _buildTextField() {
    return TextField(
      controller: widget.ctrl,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      ),
      cursorWidth: 0,
      textInputAction: TextInputAction.done,
      autofocus: widget.autoFocus,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      maxLength: widget.count,
      buildCounter: (
        BuildContext context, {
        required int currentLength,
        required bool isFocused,
        required int? maxLength,
      }) =>
          const Text(''),
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.transparent),
      onChanged: _onValueChange,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      onTap: () {

        
      },
    );
  }

  _onValueChange(value) {
    widget.onChanged?.call(value);
    for (int i = 0; i < widget.count; i++) {
      if (i < value.length) {
        _contentList[i] = value.substring(i, i + 1);
      } else {
        _contentList[i] = '';
      }
    }
    setState(() {});

    if (value.length == widget.count) {
      if (widget.unfocus) _focusNode.unfocus();

      widget.onSubmitted?.call(value, clear);
    }
  }
}
