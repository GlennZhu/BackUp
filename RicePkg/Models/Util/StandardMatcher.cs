using RicePkg.Models.ProcessStudents;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace RicePkg.Models.Util
{
    public class StandardMatcher
    {
        	/* Number of suggestions shown */
	    private static int NUM_SUGGESTION = 3;
	
    	/* The maximum tolerance of edit distance for a word to be a match for a person */
	    private static double ERROR_THRESHOLD = 0.3;

        public String denoise(String noisedString) {
	        // filter out non-letter and non space char char
	        StringBuilder sb = new StringBuilder();
	        foreach (char c in noisedString.ToCharArray()) {
		        if (c == '\n') {
			        sb.Append(' ');
		        }
		        else if (Char.IsLetter(c) || Char.IsWhiteSpace(c)) {
			        sb.Append(c);
		        }
	        }
		
	        // trim spaces
	        String output = sb.ToString();
	        output = output.Trim();
	        output = output.Replace("\\s+", " ");
		
	        // to lower case
	        output = output.ToLower();
	        return output;
        }

        public List<Student> generateMatch(String identifier, String college) {
		    List<Student> allStudent = queryByCollege(college);
            string[] strs = identifier.Split(' ');
            List<string> words = strs.OfType<string>().ToList<string>();
		    Dictionary<Student, int> counter = new Dictionary<Student, int>();
		    // count score
		    foreach (string word in words) {
			    foreach (Student person in allStudent) {
				    int minLength = person.full_name.firstname.Length;
				    minLength = (minLength < person.full_name.lastname.Length)? minLength : person.full_name.lastname.Length;
				    if (matchError(word, person) <= Math.Round(minLength * ERROR_THRESHOLD)) {					
					    if (!counter.Keys.Contains(person)) {
						    counter.Add(person, 1);
					    }else{
						    counter[person] = counter[person] + 1;
					    }
				    }
				
			    }
		    }
            //throw new Exception("have got here");

		    // choose the best one
		    int bestScore = 0;
		    List<Student> bestPerson = new List<Student>();
		    foreach (Student person in counter.Keys) {
			    if (counter[person] > bestScore) {
				    bestScore = counter[person];
				    bestPerson.Clear();
				    bestPerson.Add(person);
			    }
			    else if (counter[person] == bestScore) {
				    bestPerson.Add(person);
			    }
		    }
		    return bestPerson;
	    }


        /**
         * Get a list of all students in a college
         * */
        private List<Student> queryByCollege(String college)
        {
            List<Student> output = new List<Student>();
            // TODO query cache
            Dictionary<StudentName, List<Student>> college_map = WebApiApplication.global_student_cache[college];
            foreach (KeyValuePair<StudentName, List<Student>> pair in college_map)
            {
                List<Student> l = pair.Value;
                output.AddRange(l);
            }
            return output;
        }

        /**
         * Calculate the error of matching a person to a words
         **/
        private int matchError(String word, Student person)
        {
            int firstDis = editDistance(word, person.full_name.firstname.ToLower());
            int lastDis = editDistance(word, person.full_name.lastname.ToLower());
            return (firstDis > lastDis) ? lastDis : firstDis;
        }

        private int editDistance(string s, string t)
        {
            int n = s.Length;
            int m = t.Length;
            int[,] d = new int[n + 1, m + 1];

            // Step 1
            if (n == 0)
            {
                return m;
            }

            if (m == 0)
            {
                return n;
            }

            // Step 2
            for (int i = 0; i <= n; d[i, 0] = i++)
            {
            }

            for (int j = 0; j <= m; d[0, j] = j++)
            {
            }

            // Step 3
            for (int i = 1; i <= n; i++)
            {
                //Step 4
                for (int j = 1; j <= m; j++)
                {
                    // Step 5
                    int cost = (t[j - 1] == s[i - 1]) ? 0 : 1;

                    // Step 6
                    d[i, j] = Math.Min(
                        Math.Min(d[i - 1, j] + 1, d[i, j - 1] + 1),
                        d[i - 1, j - 1] + cost);
                }
            }
            // Step 7
            return d[n, m];
        }
    }
}