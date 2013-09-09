using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
   public class ChangePassword
    {
        [DataMember]
        public int? AssociateID { get; set; }
        [DataMember]
        public string CurrentPassword { get; set; }
        [DataMember]
        public string NewPassword { get; set; }
    }
}
