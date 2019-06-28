using System;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public class Transfer : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? TransferId { get; set; }
        public Guid CustomerId { get; set; }
        public Guid? InteractionId { get; set; }
        public string OriginatingTouchpointId { get; set; }
        public string TargetTouchpointId { get; set; }
        public string Context { get; set; }
        public DateTime? DateandTimeOfTransfer { get; set; }
        public DateTime? DateandTimeofTransferAccepted { get; set; }
        public DateTime? RequestedCallbackTime { get; set; }
        public DateTime? ActualCallbackTime { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedTouchpointId { get; set; }
        
        public void Anonymise()
        {
            Context = RandomiseText(Context);
        }

    }
}

