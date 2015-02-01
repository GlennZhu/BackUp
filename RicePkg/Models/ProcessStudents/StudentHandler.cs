using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using RicePkg.Models.JsonDeserialize;
using System.Net;
using System.Configuration;
using System.Web.Http.Tracing;
using System.Text.RegularExpressions;

namespace RicePkg.Models.ProcessStudents
{
    public class StudentHandler
    {
        public static Dictionary<String, Dictionary<StudentName, List<Student>>> initStudentCache()
        {
            Dictionary<String, Dictionary<StudentName, List<Student>>> entities = new Dictionary<String, Dictionary<StudentName, List<Student>>>();
            // Initializez colleges, then for each college add student data
            String[] colleges = System.Configuration.ConfigurationManager.AppSettings["CollegeNames"].Split(',');
            foreach (String college in colleges)
            {
                String college_lower = college.ToLower();
                Dictionary<StudentName, List<Student>> college_map = new Dictionary<StudentName, List<Student>>();
                entities.Add(college_lower, college_map);
                string json = null;
                List<Result> returnVal = new List<Result>();
                do
                {
                    json = new WebClient().DownloadString(String.Format("{0}college={1}",
                        System.Configuration.ConfigurationManager.AppSettings["SearchRicePeopleUrlPrefix"],
                        college_lower));
                    RootObject root = Newtonsoft.Json.JsonConvert.DeserializeObject<RootObject>(json);
                    returnVal = root.results;
                    // Check server error
                } while (returnVal.Count == 0);
                if (returnVal.Count > 0)
                {
                    foreach (Result res in returnVal)
                    {
                        String name = res.name.ToLower();
                        String email = res.email.ToLower();
                        string netid = res.netid.ToLower(); //TODO

                        String[] name_parts = Regex.Split(name, ", ");
                        String last_name = name_parts[0];

                        String first_name = null;
                        String[] first_name_parts = Regex.Split(name_parts[1], " ");
                        if (first_name_parts.Length > 0)
                        {
                            first_name = first_name_parts[0];
                        }

                        // TODO.
                        StudentName full_name = new StudentName();
                        full_name.firstname = first_name;
                        full_name.lastname = last_name;
                        Student s = new Student();
                        s.email = email;
                        s.netid = netid;
                        s.full_name = full_name;
                        if (!college_map.ContainsKey(full_name))
                        {
                            List<Student> l = new List<Student>();
                            l.Add(s);
                            college_map.Add(full_name, l);
                        }
                        else
                        {
                            college_map[full_name].Add(s);
                        }
                    }
                }
                else
                { // TODO retry

                }
            }
            return entities;
        }

        public static List<Student> getStudentsFromCollege(String college)
        {  //TODO lovett college or lovett??? make sure!
            college = college.ToLower();
            List<Student> items = new List<Student>();
            Dictionary<StudentName, List<Student>> college_map = WebApiApplication.global_student_cache[college];
            foreach (KeyValuePair<StudentName, List<Student>> pair in college_map)
            {
                List<Student> l = pair.Value;
                items.AddRange(l);
            }
            return items;
        }

        public static List<Student> getCandidates(string fn, string ln, string college)
        {
            ln = ln.ToLower();
            fn = ln.ToLower();
            college = college.ToLower();
            List<Student> items = new List<Student>();
            Dictionary<StudentName, List<Student>> college_map = WebApiApplication.global_student_cache[college];
            StudentName full_name = new StudentName();
            full_name.firstname = fn; //TODO what if only first name or last name
            full_name.lastname = ln;

            if (college_map.ContainsKey(full_name))
            {
                items.AddRange(college_map[full_name]);
            }

            //foreach (KeyValuePair<StudentName, List<Student>> pair in college_map)
            //{
            //    StudentName sn = pair.Key;
            //    List<Student> l = pair.Value;
            //    if (sn.Equals(full_name)) {
            //        items.AddRange(l);
            //    }
            //}
            return items.Count == 0 ? RicePeople.get("", ln, college) : items;
        }

        public static object Request { get; set; }
    }
}