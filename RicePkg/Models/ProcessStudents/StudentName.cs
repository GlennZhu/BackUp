﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.ProcessStudents
{
    public class StudentName
    {
        public string firstname { get; set; }
        public string lastname { get; set; }
        public String toString()
        {
            return firstname + "-" + lastname;
        }
        public bool Equals(StudentName other)
        {
            return other.firstname.Equals(this.firstname) && other.lastname.Equals(this.lastname);
        }
        public override int GetHashCode()
        {
            return this.firstname.GetHashCode() + this.lastname.GetHashCode();
        }
    }
}