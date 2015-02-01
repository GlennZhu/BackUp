using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RicePkg.Models.ErrorMessage
{
    public class GeneralFailureMessage
    {
        public string detail { get; set; }

        public GeneralFailureMessage()
        {
            detail = "Internal error";
        }

        public GeneralFailureMessage(string message)
        {
            detail = message;
        }
    }
}