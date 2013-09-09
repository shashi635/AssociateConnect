using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    [DataContract]
    public class Phone
    {
        #region ctor
        public Phone()     {  }
        #endregion

       #region public members
        [DataMember]
        public int PhoneID { get; set; }
        [DataMember]
        public int PhoneTypeID { get; set; }
        [DataMember]
        public PhoneType PhoneType { get; set; }
        [DataMember]
        public string PhoneNo { get; set; }
       #endregion
       
    }
}
