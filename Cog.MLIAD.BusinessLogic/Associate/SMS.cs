using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class SMS
    {
        #region public members
        [DataMember]
        public string userID { get; set; }

        [DataMember]
        public string password { get; set; }

        [DataMember]
        public string smsBody { get; set; }

        [DataMember]
        public string toList { get; set; }

        [DataMember]
        public bool isMultiple { get; set; }
     
        #endregion public members
    }
}
