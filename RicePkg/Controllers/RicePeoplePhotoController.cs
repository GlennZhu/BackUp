using RicePkg.Models.ErrorMessage;
using RicePkg.Models.JsonDeserialize;
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
        public HttpResponseMessage Get(string imageUrl)
        {
            try
            {
                // Pass  the url to the back end and get the raw string back


                // Fake response
                Result r = new Result();
                r.name = "testname";
                r.email = "testemail";
                List<Result> fake = new List<Result>();
                fake.Add(r);
                return Request.CreateResponse(HttpStatusCode.OK, fake);
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new GeneralFailureMessage());
            }
        }
    }
}
