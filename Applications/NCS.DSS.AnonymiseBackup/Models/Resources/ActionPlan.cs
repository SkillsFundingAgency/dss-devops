using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{

public class ActionPlan : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? ActionPlanId { get; set; }

        public Guid? CustomerId { get; set; }
        public Guid? InteractionId { get; set; }
        public DateTime? DateActionPlanCreated { get; set; }

        public bool? CustomerCharterShownToCustomer { get; set; }

        public DateTime? DateAndTimeCharterShown { get; set; }
        public DateTime? DateActionPlanSentToCustomer { get; set; }

        public ActionPlanDeliveryMethod? ActionPlanDeliveryMethod { get; set; }

        public DateTime? DateActionPlanAcknowledged { get; set; }
        public PriorityCustomer? PriorityCustomer { get; set; }
        public string CurrentSituation { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            CurrentSituation = RandomiseText(CurrentSituation);
        }
   
    }


}
