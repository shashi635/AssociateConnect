using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
   public class SMSAccount
    {
        public int id { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string phoneNumber { get; set; }
        public int? sentSMS { get; set; }
    }
}
