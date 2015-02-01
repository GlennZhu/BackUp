using RicePkg.Models.ErrorMessage;
using RicePkg.Models.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace RicePkg.Controllers
{
    public class SendEmailController : ApiController
    {
        // GET api/<controller>/
        public HttpResponseMessage Get(string imageUrl, string email)
        {
            try
            {
                if (imageUrl == null)
                    imageUrl = "";
                Email.sendMail(email, imageUrl);
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new GeneralFailureMessage());
            }
        }
    }
}
