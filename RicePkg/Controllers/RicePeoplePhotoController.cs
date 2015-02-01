using RicePkg.Models.ErrorMessage;
using RicePkg.Models.JsonDeserialize;
using RicePkg.Models.ProcessStudents;
using RicePkg.Models.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace RicePkg.Controllers
{
    public class RicePeoplePhotoController : ApiController
    {
        // GET api/<controller>/
        // Get a image url, return a list of potential candidates
        public HttpResponseMessage Get(string imageUrl)
        {
            try
            {
                string json = new WebClient().DownloadString(String.Format("{0}img={1}",
                System.Configuration.ConfigurationManager.AppSettings["OcrPrefix"],
                imageUrl));
                OcrResponse root = Newtonsoft.Json.JsonConvert.DeserializeObject<OcrResponse>(json);
                // TODO Get rid of Fake College
                String fake_college = "lovett";
                if (root.success)
                {
                    string parsedContent = root.value; // TO FN LN 2132 ST HOUSTON TX 77005 USA
                    List<Student> results = (new StandardMatcher()).generateMatch(parsedContent, fake_college);
                    return Request.CreateResponse(HttpStatusCode.OK, results);
                }
                else { 
                    // TODO what if this happens.
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, new GeneralFailureMessage("Ocr API fail"));
                }


                //// Fake response
                //Result r = new Result();
                //r.name = "testname";
                //r.email = "testemail";
                //List<Result> fake = new List<Result>();
                //fake.Add(r);
                //return Request.CreateResponse(HttpStatusCode.OK, fake);
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new GeneralFailureMessage("Get RicePeopePhoto: " + e.Message));
            }
        }

    }
}
