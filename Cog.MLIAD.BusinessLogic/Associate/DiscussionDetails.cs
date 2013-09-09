using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class DiscussionDetails
    {
        #region ctor
        public DiscussionDetails()
        {

        }
        #endregion
        #region public members
            public int TopicDetailID { get; set; }
            public string DetailDesc { get; set; }
            public DateTime? CreatedOn { get; set; }
            public string PostDateTimeString
            {
                get
                {
                    return CreatedOn.HasValue ? CreatedOn.Value.ToString("MM/dd/yyyy") : "";
                }
                set
                {
                    DateTime dt;
                    if (DateTime.TryParse(value, out dt))
                        CreatedOn = dt;
                }
            }  
            public int ParentID { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedByname { get; set; }
        #endregion
    }
}
