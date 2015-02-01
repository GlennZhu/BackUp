using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace RicePkg.Models.Util
{
    public class Email
    {

        public static bool sendMail(string recipient, string imageUrl)
        {
            bool result = true;
            String hasImage = "Dear student,<br>Please come get your package.<br>See an image of your package <a href='" + imageUrl + "'>here</a>.<br>Your deligent coordinator";
            String noImage = "Dear student,<br>Please come get your package.<br>Your deligent coordinator";
            try
            {
                String body = hasImage;
                if (imageUrl == null || imageUrl.Length == 0) {
                    body = noImage;
                }
                SendMailHelper("riceowlexpress@gmail.com", "HackRice2015!", "smtp.gmail.com", "OwlExpress", recipient, "You have a package", body);
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }

        private static bool SendMailHelper(string fromAddress, string fromPassword, string smtpServer, string fromName, string recipient, string subject, string body)
        {
            bool result = true;
            try
            {
                SmtpClient smtp = new SmtpClient
                {
                    Host = smtpServer, // smtp server address here…
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    Credentials = new System.Net.NetworkCredential(fromAddress, fromPassword),
                    Timeout = 30000,
                };
                MailMessage message = new MailMessage(fromAddress, recipient, subject, body);
                message.IsBodyHtml = true;
                smtp.Send(message);
                }
                catch (Exception ex)
                {
                    result = false;
                }
                return result;
          }
     }
}