using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using RicePkg.Models.JsonDeserialize;

namespace RicePkg.Models
{
    public class RicePeople
    {
        //public static List<RicePerson> get(string firstname, string lastname)
        public static List<Result> get(string firstname, string lastname, string college)
        {
            string json = new WebClient().DownloadString(String.Format("{0}firstname={1}&lastname={2}&college={3}", 
                System.Configuration.ConfigurationManager.AppSettings["SearchRicePeopleUrlPrefix"],
                firstname,
                lastname,
                college));
            RootObject root = Newtonsoft.Json.JsonConvert.DeserializeObject<RootObject>(json);
            List<Result> returnVal = root.results;
            // If found
            if (returnVal.Count > 0)
                return returnVal;
            else
                return get(null, lastname, college);
        }
    }
}