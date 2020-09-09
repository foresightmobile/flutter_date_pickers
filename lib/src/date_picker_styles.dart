import 'package:flutter/material.dart';

/// 0 points to Sunday, and 6 points to Saturday.
typedef DayHeaderStyle DayHeaderStyleBuilder(int dayOfTheWeek);

/// Common styles for date pickers.
///
/// To define more styles for date pickers which allow select some range
/// (e.g. [RangePicker], [WeekPicker]) use [DatePickerRangeStyles].
class DatePickerStyles {
  /// Used for title of displayed period (e.g. month for day picker and year for month picker).
  final TextStyle displayedPeriodTitle;

  final TextStyle currentDateStyle;

  final TextStyle disabledDateStyle;

  final TextStyle selectedDateStyle;

  final BoxDecoration currentDateDecoration;

  /// Used for date which is neither current nor disabled nor selected.
  final TextStyle defaultDateTextStyle;

  final BoxDecoration selectedSingleDateDecoration;

  /// Style for the day header.
  ///
  /// If you need to customize day header's style depends on day of the week
  /// use [dayHeaderStyleBuilder] instead.
  final DayHeaderStyle dayHeaderStyle;

  /// Builder to customize styles for day headers depends on day of the week.
  /// Where 0 points to Sunday and 6 points to Saturday.
  ///
  /// Builder must return not null value for every weekday from 0 to 6.
  ///
  /// If styles should be the same for any day of the week use [dayHeaderStyle] instead.
  final DayHeaderStyleBuilder dayHeaderStyleBuilder;

  /// Widget which will be shown left side of the shown page title.
  /// User goes to previous data period by click on it.
  final Widget prevIcon;

  /// Widget which will be shown right side of the shown page title.
  /// User goes to next data period by click on it.
  final Widget nextIcon;

  /// Index of the first day of week, where 0 points to Sunday, and 6 points to
  /// Saturday. Must not be less 0 or more then 6.
  ///
  /// Can be null. In this case value from current locale will be used.
  final int firstDayOfeWeekIndex;

  DatePickerStyles({
    this.displayedPeriodTitle,
    this.currentDateStyle,
    this.disabledDateStyle,
    this.selectedDateStyle,
    this.selectedSingleDateDecoration,
    this.defaultDateTextStyle,
    this.dayHeaderStyleBuilder,
    this.currentDateDecoration,
    this.dayHeaderStyle,
    this.firstDayOfeWeekIndex,
    Widget prevIcon,
    Widget nextIcon
  }) : assert(!(dayHeaderStyle != null && dayHeaderStyleBuilder != null),
        "Should be only one from: dayHeaderStyleBuilder, dayHeaderStyle."),
       assert(dayHeaderStyleBuilder == null || _validateDayHeaderStyleBuilder(dayHeaderStyleBuilder),
        "dayHeaderStyleBuilder must return not null value from every weekday (from 0 to 6)."),
       assert(_validateFirstDayOfWeek(firstDayOfeWeekIndex),
        "firstDayOfeWeekIndex must be null or in correct range (from 0 to 6)."),
      this.nextIcon = nextIcon ?? const Icon(Icons.chevron_right),
      this.prevIcon = prevIcon ?? const Icon(Icons.chevron_left);

  /// Return new [DatePickerStyles] object where fields with null values set with defaults from theme.
  DatePickerStyles fulfillWithTheme(ThemeData theme) {
    Color accentColor = theme.accentColor;

    TextStyle _displayedPeriodTitle =
        displayedPeriodTitle ?? theme.textTheme.subtitle1;
    TextStyle _currentDateStyle = currentDateStyle ??
        theme.textTheme.bodyText1.copyWith(color: theme.accentColor);
    TextStyle _disabledDateStyle = disabledDateStyle ??
        theme.textTheme.bodyText2.copyWith(color: theme.disabledColor);
    TextStyle _selectedDateStyle =
        selectedDateStyle ?? theme.accentTextTheme.bodyText1;
    TextStyle _defaultDateTextStyle =
        defaultDateTextStyle ?? theme.textTheme.bodyText2;
    BoxDecoration _selectedSingleDateDecoration =
        selectedSingleDateDecoration ??
            BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)));
    BoxDecoration _currentDateDecoration = _currentDateStyle ?? BoxDecoration(
      color: accentColor,
      borderRadius: BorderRadius.circular(10.0)
    );

    DayHeaderStyle _dayHeaderStyle;
    if (dayHeaderStyleBuilder == null) {
      _dayHeaderStyle = DayHeaderStyle(textStyle: theme.textTheme.caption);
    }

    return DatePickerStyles(
        disabledDateStyle: _disabledDateStyle,
        currentDateStyle: _currentDateStyle,
        displayedPeriodTitle: _displayedPeriodTitle,
        selectedDateStyle: _selectedDateStyle,
        selectedSingleDateDecoration: _selectedSingleDateDecoration,
        defaultDateTextStyle: _defaultDateTextStyle,
        dayHeaderStyle: _dayHeaderStyle,
        currentDateDecoration: _currentDateDecoration,
        dayHeaderStyleBuilder: dayHeaderStyleBuilder,
        nextIcon: nextIcon,
        prevIcon: prevIcon
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is DatePickerStyles
        && other.displayedPeriodTitle == displayedPeriodTitle
        && other.currentDateStyle == currentDateStyle
        && other.disabledDateStyle == disabledDateStyle
        && other.selectedDateStyle == selectedDateStyle
        && other.defaultDateTextStyle == defaultDateTextStyle
        && other.selectedSingleDateDecoration == selectedSingleDateDecoration
        && other.dayHeaderStyle == dayHeaderStyle
        && other.dayHeaderStyleBuilder == dayHeaderStyleBuilder
        && other.prevIcon == prevIcon
        && other.nextIcon == nextIcon
        && other.currentDateDecoration == currentDateDecoration
        && other.firstDayOfeWeekIndex == firstDayOfeWeekIndex;
  }

  @override
  int get hashCode {
    return hashValues(
        displayedPeriodTitle,
        currentDateStyle,
        disabledDateStyle,
        selectedDateStyle,
        defaultDateTextStyle,
        selectedSingleDateDecoration,
        dayHeaderStyle,
        dayHeaderStyleBuilder,
        prevIcon,
        nextIcon,
        firstDayOfeWeekIndex,
        currentDateDecoration
    );
  }

  static bool _validateDayHeaderStyleBuilder(DayHeaderStyleBuilder builder) {
    List<int> weekdays = const [0, 1, 2, 3, 4, 5, 6];
    bool valid = weekdays.every((int weekday) => builder(weekday) != null);

    return valid;
  }

  static bool _validateFirstDayOfWeek(int index) {
    if (index == null) return true;

    bool valid = index >= 0 && index <= 6;

    return valid;
  }
}

/// Styles for date pickers which allow select some range (e.g. [RangePicker], [WeekPicker]).
class DatePickerRangeStyles extends DatePickerStyles {
  /// Decoration for the first date of the selected range.
  final BoxDecoration selectedPeriodStartDecoration;

  /// Text style for the first date of the selected range.
  ///
  /// If null - default [DatePickerStyles.selectedDateStyle] will be used.
  final TextStyle selectedPeriodStartTextStyle;

  /// Decoration for the last date of the selected range.
  final BoxDecoration selectedPeriodLastDecoration;

  /// Text style for the last date of the selected range.
  ///
  /// If null - default [DatePickerStyles.selectedDateStyle] will be used.
  final TextStyle selectedPeriodEndTextStyle;

  /// Decoration for the date of the selected range which is not first date and not end date of this range.
  ///
  /// If there is only one date selected [DatePickerStyles.selectedSingleDateDecoration] will be used.
  final BoxDecoration selectedPeriodMiddleDecoration;

  /// Text style for the middle date of the selected range.
  ///
  /// If null - default [DatePickerStyles.selectedDateStyle] will be used.
  final TextStyle selectedPeriodMiddleTextStyle;

  /// Return new [DatePickerRangeStyles] object where fields with null values set with defaults from given theme.
  DatePickerRangeStyles fulfillWithTheme(ThemeData theme) {
    Color accentColor = theme.accentColor;

    DatePickerStyles commonStyles = super.fulfillWithTheme(theme);

    final BoxDecoration _selectedPeriodStartDecoration =
        selectedPeriodStartDecoration ??
            BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
            );

    final BoxDecoration _selectedPeriodLastDecoration =
        selectedPeriodLastDecoration ??
            BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            );

    final BoxDecoration _selectedPeriodMiddleDecoration =
        selectedPeriodMiddleDecoration ??
            BoxDecoration(
              color: accentColor,
              shape: BoxShape.rectangle,
            );

    final TextStyle _selectedPeriodStartTextStyle =
        selectedPeriodStartTextStyle ?? commonStyles.selectedDateStyle;

    final TextStyle _selectedPeriodMiddleTextStyle =
        selectedPeriodMiddleTextStyle ?? commonStyles.selectedDateStyle;

    final TextStyle _selectedPeriodEndTextStyle =
        selectedPeriodEndTextStyle ?? commonStyles.selectedDateStyle;

    return DatePickerRangeStyles(
        disabledDateStyle: commonStyles.disabledDateStyle,
        currentDateStyle: commonStyles.currentDateStyle,
        displayedPeriodTitle: commonStyles.displayedPeriodTitle,
        selectedDateStyle: commonStyles.selectedDateStyle,
        selectedSingleDateDecoration: commonStyles.selectedSingleDateDecoration,
        defaultDateTextStyle: commonStyles.defaultDateTextStyle,
        dayHeaderStyle: commonStyles.dayHeaderStyle,
        dayHeaderStyleBuilder: commonStyles.dayHeaderStyleBuilder,
        firstDayOfWeekIndex: firstDayOfeWeekIndex,
        currentDateDecoration: commonStyles.currentDateDecoration,
        selectedPeriodStartDecoration: _selectedPeriodStartDecoration,
        selectedPeriodMiddleDecoration: _selectedPeriodMiddleDecoration,
        selectedPeriodLastDecoration: _selectedPeriodLastDecoration,
        selectedPeriodStartTextStyle: _selectedPeriodStartTextStyle,
        selectedPeriodMiddleTextStyle: _selectedPeriodMiddleTextStyle,
        selectedPeriodEndTextStyle: _selectedPeriodEndTextStyle,
    );
  }

  DatePickerRangeStyles({
    displayedPeriodTitle,
    currentDateStyle,
    disabledDateStyle,
    selectedDateStyle,
    selectedSingleDateDecoration,
    defaultDateTextStyle,
    dayHeaderStyle,
    dayHeaderStyleBuilder,
    currentDateDecoration,
    nextIcon,
    prevIcon,
    firstDayOfWeekIndex,
    this.selectedPeriodLastDecoration,
    this.selectedPeriodMiddleDecoration,
    this.selectedPeriodStartDecoration,
    this.selectedPeriodStartTextStyle,
    this.selectedPeriodMiddleTextStyle,
    this.selectedPeriodEndTextStyle,
  }) : super(
            displayedPeriodTitle: displayedPeriodTitle,
            currentDateStyle: currentDateStyle,
            disabledDateStyle: disabledDateStyle,
            selectedDateStyle: selectedDateStyle,
            selectedSingleDateDecoration: selectedSingleDateDecoration,
            defaultDateTextStyle: defaultDateTextStyle,
            currentDateDecoration: currentDateDecoration,
            dayHeaderStyle: dayHeaderStyle,
            dayHeaderStyleBuilder: dayHeaderStyleBuilder,
            nextIcon: nextIcon,
            prevIcon: prevIcon,
            firstDayOfeWeekIndex: firstDayOfWeekIndex
       );

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is DatePickerRangeStyles
        && other.selectedPeriodStartDecoration == selectedPeriodStartDecoration
        && other.selectedPeriodStartTextStyle == selectedPeriodStartTextStyle
        && other.selectedPeriodLastDecoration == selectedPeriodLastDecoration
        && other.selectedPeriodEndTextStyle == selectedPeriodEndTextStyle
        && other.selectedPeriodMiddleDecoration == selectedPeriodMiddleDecoration
        && other.selectedPeriodMiddleTextStyle == selectedPeriodMiddleTextStyle
        && other.displayedPeriodTitle == displayedPeriodTitle
        && other.currentDateStyle == currentDateStyle
        && other.disabledDateStyle == disabledDateStyle
        && other.selectedDateStyle == selectedDateStyle
        && other.defaultDateTextStyle == defaultDateTextStyle
        && other.selectedSingleDateDecoration == selectedSingleDateDecoration
        && other.dayHeaderStyle == dayHeaderStyle
        && other.dayHeaderStyleBuilder == dayHeaderStyleBuilder
        && other.prevIcon == prevIcon
        && other.nextIcon == nextIcon
        && other.currentDateDecoration == currentDateDecoration
        && other.firstDayOfeWeekIndex == firstDayOfeWeekIndex;
  }

  @override
  int get hashCode {
    return hashValues(
      selectedPeriodStartDecoration,
      selectedPeriodStartTextStyle,
      selectedPeriodLastDecoration,
      selectedPeriodEndTextStyle,
      selectedPeriodMiddleDecoration,
      selectedPeriodMiddleTextStyle,
      displayedPeriodTitle,
      currentDateStyle,
      disabledDateStyle,
      selectedDateStyle,
      defaultDateTextStyle,
      selectedSingleDateDecoration,
      dayHeaderStyle,
      dayHeaderStyleBuilder,
      prevIcon,
      nextIcon,
      firstDayOfeWeekIndex,
      currentDateDecoration,
    );
  }
}


/// Style for the day header in date picker.
class DayHeaderStyle {
  /// If null - [textTheme.caption] from the Theme will be used.
  final TextStyle textStyle;

  /// If null - no decoration will be applied for the day header;
  final BoxDecoration decoration;

  const DayHeaderStyle({
    this.textStyle,
    this.decoration
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is DayHeaderStyle
        && other.textStyle == textStyle
        && other.decoration == decoration;
  }

  @override
  int get hashCode {
    return hashValues(
      textStyle,
      decoration
    );
  }
}