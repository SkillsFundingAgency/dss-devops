using System;
using NCS.DSS.Anonymise.ReferenceData;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Outcome : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? OutcomeId { get; set; }
        public Guid? CustomerId { get; set; }
        public Guid? ActionPlanId { get; set; }
        public string SubcontractorId { get; set; }
        public OutcomeType? OutcomeType { get; set; }
        public DateTime? OutcomeClaimedDate { get; set; }
        public DateTime? OutcomeEffectiveDate { get; set; }
        public string TouchpointId { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        public string CreatedBy { get; set; }

        public void Anonymise()
        {

        }
    }

}
