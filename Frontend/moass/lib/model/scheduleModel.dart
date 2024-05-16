class Schedule {
  final String curriculumId;
  final String date;
  final List<Course> courses;

  Schedule({
    required this.curriculumId,
    required this.date,
    required this.courses,
  });

  // fromJson 메서드
  factory Schedule.fromJson(Map<String, dynamic> json) {
    var coursesJson = json['courses'] as List;
    List<Course> coursesList =
        coursesJson.map((course) => Course.fromJson(course)).toList();

    return Schedule(
      curriculumId: json['curriculumId'],
      date: json['date'],
      courses: coursesList,
    );
  }

  // toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'curriculumId': curriculumId,
      'date': date,
      'courses': courses.map((course) => course.toJson()).toList(),
    };
  }
}

class Course {
  final String period;
  final String majorCategory;
  final String minorCategory;
  final String title;
  final String teacher;
  final String room;

  Course({
    required this.period,
    required this.majorCategory,
    required this.minorCategory,
    required this.title,
    required this.teacher,
    required this.room,
  });

  // fromJson 메서드
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      period: json['period'],
      majorCategory: json['majorCategory'],
      minorCategory: json['minorCategory'],
      title: json['title'],
      teacher: json['teacher'],
      room: json['room'],
    );
  }

  // toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'majorCategory': majorCategory,
      'minorCategory': minorCategory,
      'title': title,
      'teacher': teacher,
      'room': room,
    };
  }
}
