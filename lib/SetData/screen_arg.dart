

// class ServiceScrAr {
//   final String appointmentType;
//   final int serviceTimeMin;
//   final String openingTime;
//   final String closingTime;
//   ServiceScrArg(this.appointmentType, this.serviceTimeMin,this.openingTime,this.closingTime);
// }

class ChooseTimeScrArg {
  final String appointmentType;
  final int serviceTimeMIn;
  final String selectedTime;
  final String selectedDate;

  ChooseTimeScrArg(this.appointmentType, this.serviceTimeMIn, this.selectedTime,
      this.selectedDate);
}

class PatientDetailsArg {
  final String pFirstName;
  final String pLastName;
  final String pPhn;
  final String pEmail;
  final String desc;
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
      this.appointmentType,
      this.serviceTimeMIn,
      this.selectedTime,
      this.selectedDate,
  );
}
