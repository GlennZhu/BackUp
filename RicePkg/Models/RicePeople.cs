using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using RicePkg.Models.JsonDeserialize;
using RicePkg.Models.ProcessStudents;
using System.Text.RegularExpressions;

namespace RicePkg.Models
{
    public class RicePeople
    {
        //public static List<RicePerson> get(string firstname, string lastname)
        public static List<Student> get(string firstname, string lastname, string college)
        {
            string json = new WebClient().DownloadString(String.Format("{0}firstname={1}&lastname={2}&college={3}", 
                System.Configuration.ConfigurationManager.AppSettings["SearchRicePeopleUrlPrefix"],
                firstname,
                lastname,
                college));
            RootObject root = Newtonsoft.Json.JsonConvert.DeserializeObject<RootObject>(json);
            List<Result> results = root.results;
            List<Student> returnVal = new List<Student>();
            foreach (Result result in results)
            {
                Student toAdd = new Student();
                toAdd.email = result.email;
                toAdd.netid = result.netid;

                StudentName name = new StudentName();
                String[] words = Regex.Split(result.name, ", ");
                name.firstname = words[0];
                name.lastname = words[words.Length - 1];

                toAdd.full_name = name;
                returnVal.Add(toAdd);
            }
            return returnVal;
        }
    }
}