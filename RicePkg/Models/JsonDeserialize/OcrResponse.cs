using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.JsonDeserialize
{
    public class OcrResponse
    {
        public bool success { get; set; }
        public string img { get; set; }
        public string value { get; set; }
    }
}