using System;
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
        public override bool Equals(object other)
        {
            if (other == null)
            {
                return false;
            }
            if (other.GetType() != GetType())
            {
                return false;
            }
            StudentName casted = (StudentName)other;
            return casted.firstname.Equals(this.firstname) && casted.lastname.Equals(this.lastname);
        }
        public override int GetHashCode()
        {
            return firstname.GetHashCode() ^ lastname.GetHashCode();
        }
    }
}