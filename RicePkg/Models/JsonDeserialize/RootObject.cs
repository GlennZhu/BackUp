using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.JsonDeserialize
{
    public class RootObject
    {
        public Stats stats { get; set; }
        public Paging paging { get; set; }
        public List<Result> results { get; set; }
    }
}