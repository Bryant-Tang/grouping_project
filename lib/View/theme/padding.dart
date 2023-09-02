import 'package:flutter/material.dart';

class AppPadding extends Padding{
  const AppPadding({
    super.key, required super.padding, super.child
  });
  
  factory AppPadding.large({
    Widget? child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: child ?? const SizedBox.shrink()
  );

  factory AppPadding.medium({
    Widget? child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: child ?? const SizedBox.shrink()
  );

  factory AppPadding.small({
    Widget? child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.all(10),
    child: child ?? const SizedBox.shrink()
  );

  factory AppPadding.object({
    Widget? child,
    EdgeInsetsGeometry? padding
  }) => AppPadding(
    padding: padding ?? const EdgeInsets.all(20),
    child: child ?? const SizedBox.shrink()
  );
}