using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Role
    {
        [DataMember]
        public int RoleID { get; set; }
        [DataMember]
        public string RoleDesc { get; set; }
    }

}
