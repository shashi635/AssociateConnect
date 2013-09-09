using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Cog.MLIAD.Data;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class Discussion
    {
        #region ctor
        public Discussion()
        {

        }
        #endregion


        #region public members
        public string TopicDesc { get; set; }
        public string TopicHeader { get; set; }
        public int? CommentCount { get; set; }
        public int TopicID { get; set; }
        public DateTime? PostDateTime { get; set; }
        public string PostDateTimeString
        {
            get
            {
                return PostDateTime.HasValue ? PostDateTime.Value.ToString("MM/dd/yyyy") : "";
            }
            set
            {
                DateTime dt;
                if (DateTime.TryParse(value, out dt))
                    PostDateTime = dt;
            }
        }  
        public bool? IsParent { get; set; }
        public int CreatedBy { get; set; }
        public string CreatedByname { get; set; }
        public int GroupID { get; set; }
        public Group Group ; 
        public Category Category;
        public DiscussionDetails Details;
        #endregion

        #region public methods
       
        #endregion

    }
}
