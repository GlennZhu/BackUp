﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.ProcessStudents
{
    public class Student
    {
        public StudentName full_name { get; set; }
        public string netid { get; set; }
        public string email { get; set; }
    }
}