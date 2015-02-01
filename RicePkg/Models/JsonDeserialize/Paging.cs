using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.JsonDeserialize
{
    public class Paging
    {
        public int page { get; set; }
        public List<object> pagerange { get; set; }
        public int pages { get; set; }
        public int resultend { get; set; }
        public int resultstart { get; set; }
    }
}