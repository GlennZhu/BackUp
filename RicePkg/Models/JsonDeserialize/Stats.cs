using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.JsonDeserialize
{
    public class Stats
    {
        public string count { get; set; }
        public string time { get; set; }
        public bool error { get; set; }

        public override string ToString() {
            return string.Format("count: {0}, time: {1}, error: {2}", count, time, error);
        }
    }
}