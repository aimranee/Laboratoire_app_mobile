class ChooseTimeScrArg {
  final String appointmentType;
  final int serviceTimeMIn;
  final String selectedTime;
  final String selectedDate;
  ChooseTimeScrArg(this.appointmentType, this.serviceTimeMIn, this.selectedTime, this.selectedDate);
}

class PatientDetailsArg {
  final String pFirstName;
  final String pLastName;
  final String pPhn;
  final String pEmail;
  final String desc;
  final String pCity;
  final String analyses;
  final double price;
  final String appointmentType;
  final int serviceTimeMIn;
  final String selectedTime;
  final String selectedDate;
  PatientDetailsArg(
      this.pFirstName,
      this.pLastName,
      this.pPhn,
      this.pEmail,
      this.desc,
      this.pCity,
      this.analyses,
      this.price,
      this.appointmentType,
      this.serviceTimeMIn,
      this.selectedTime,
      this.selectedDate,
  );
}
