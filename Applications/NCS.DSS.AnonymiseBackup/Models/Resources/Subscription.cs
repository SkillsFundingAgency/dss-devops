using System;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Subscription : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? SubscriptionId { get; set; }

        public Guid? CustomerId { get; set; }

        public string TouchPointId { get; set; }
        public bool? Subscribe { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedBy { get; set; }
        

        public void Anonymise()
        {

        }
        
    }
}
