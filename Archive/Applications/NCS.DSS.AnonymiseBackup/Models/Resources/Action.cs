using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Action  : AnonHelper, IAnonymise
    {

        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? ActionId { get; set; }
        public Guid? CustomerId { get; set; }
        public Guid? ActionPlanId { get; set; }
        public DateTime? DateActionAgreed { get; set; }
        public DateTime? DateActionAimsToBeCompletedBy { get; set; }
        public DateTime? DateActionActuallyCompleted { get; set; }
        public string ActionSummary { get; set; }
        public string SignpostedTo { get; set; }
        public ActionType? ActionType { get; set; }
        public ActionStatus? ActionStatus { get; set; }
        public PersonResponsible? PersonResponsible { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {
            ActionSummary = RandomiseText(ActionSummary);
            SignpostedTo = RandomiseText(SignpostedTo);
        }        
    }
}
