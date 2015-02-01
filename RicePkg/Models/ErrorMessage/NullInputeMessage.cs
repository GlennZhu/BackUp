using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.ErrorMessage
{
    public class NullInputeMessage
    {
        public string detail { get; set; }

        public NullInputeMessage()
        {
            detail = "Has null input";
        }
    }
}