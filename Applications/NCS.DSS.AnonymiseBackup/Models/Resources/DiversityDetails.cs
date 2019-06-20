using System;
using System.ComponentModel;
using NCS.DSS.AnonymiseBackup.Helpers;

namespace NCS.DSS.AnonymiseBackup.Models.Resources
{
    public enum Ethnicity
    {
        [Description("English / Welsh / Scottish / Northern Irish / British")]
        EnglishWelshScottishNorthernIrishBritish = 31,

        Irish = 32,

        [Description("Gypsy or Irish Traveller")]
        GypsyIrishTraveller = 33,

        [Description("Any Other White background")]
        AnyOtherWhiteBackground = 34,

        [Description("White and Black Caribbean")]
        WhiteAndBlackCaribbean = 35,

        [Description("White and Black African")]
        WhiteAndBlackAfrican = 36,

        [Description("White and Asian")]
        WhiteAndAsian = 37,

        [Description("Any Other Mixed / multiple ethnic background")]
        AnyOtherMixedMultipleEthnicBackground = 38,

        Indian = 39,
        Pakistani = 40,
        Bangladeshi = 41,
        Chinese = 42,

        [Description("Any other Asian background")]
        AnyOtherAsianBackground = 43,

        African = 44,
        Caribbean = 45,

        [Description("Any other Black / African / Caribbean background")]
        AnyOtherBlackAfricanCaribbeanBackground = 46,

        Arab = 47,

        [Description("Any other ethnic group")]
        AnyOtherEthnicGroup = 98,

        [Description("Not provided")]
        NotProvided = 99
    }

    public enum PrimaryLearningDifficultyOrDisability
    {
        [Description("Visual impairment")]
        VisualImpairment = 4,

        [Description("Hearing impairment")]
        HearingImpairment = 5,

        [Description("Disability affecting mobility")]
        DisabilityAffectingMobility = 6,

        [Description("Profound complex disabilities")]
        ProfoundComplexDisabilities = 7,

        [Description("Social and emotional difficulties")]
        SocialAndEmotionalDifficulties = 8,

        [Description("Mental health difficulty")]
        MentalHealthDifficulty = 9,

        [Description("Moderate learning difficulty")]
        ModerateLearningDifficulty = 10,

        [Description("Severe learning difficulty")]
        SevereLearningDifficulty = 11,

        Dyslexia = 12,
        Dyscalculia = 13,

        [Description("Autism spectrum disorder")]
        AutismSpectrumDisorder = 14,

        [Description("Asperger's syndrome")]
        AspergersSyndrome = 15,

        [Description("Temporary disability after illness (for example post viral) or accident")]
        TemporaryDisabilityAfterIllnessOrAccident = 16,

        [Description("Speech, Language and Communication Needs")]
        SpeechLanguageAndCommunicationNeeds = 17,

        [Description("Other physical disability")]
        OtherPhysicalDisability = 93,

        [Description("Other specific learning difficulty (e.g. Dyspraxia)")]
        OtherSpecificLearningDifficulty = 94,

        [Description("Other medical condition (for example epilepsy, asthma, diabetes)")]
        OtherMedicalCondition = 95,

        [Description("Other learning difficulty")]
        OtherLearningDifficulty = 96,

        [Description("Other disability")]
        OtherDisability = 97,

        [Description("Prefer not to say")]
        PreferNotToSay = 98,

        [Description("Not provided")]
        NotProvided = 99

    }

    public enum SecondaryLearningDifficultyOrDisability
    {
        [Description("Visual impairment")]
        VisualImpairment = 4,

        [Description("Hearing impairment")]
        HearingImpairment = 5,

        [Description("Disability affecting mobility")]
        DisabilityAffectingMobility = 6,

        [Description("Profound complex disabilities")]
        ProfoundComplexDisabilities = 7,

        [Description("Social and emotional difficulties")]
        SocialAndEmotionalDifficulties = 8,

        [Description("Mental health difficulty")]
        MentalHealthDifficulty = 9,

        [Description("Moderate learning difficulty")]
        ModerateLearningDifficulty = 10,

        [Description("Severe learning difficulty")]
        SevereLearningDifficulty = 11,

        Dyslexia = 12,
        Dyscalculia = 13,

        [Description("Autism spectrum disorder")]
        AutismSpectrumDisorder = 14,

        [Description("Asperger's syndrome")]
        AspergersSyndrome = 15,

        [Description("Temporary disability after illness (for example post viral) or accident")]
        TemporaryDisabilityAfterIllnessOrAccident = 16,

        [Description("Speech, Language and Communication Needs")]
        SpeechLanguageAndCommunicationNeeds = 17,

        [Description("Other physical disability")]
        OtherPhysicalDisability = 93,

        [Description("Other specific learning difficulty (e.g. Dyspraxia)")]
        OtherSpecificLearningDifficulty = 94,

        [Description("Other medical condition (for example epilepsy, asthma, diabetes)")]
        OtherMedicalCondition = 95,

        [Description("Other learning difficulty")]
        OtherLearningDifficulty = 96,

        [Description("Other disability")]
        OtherDisability = 97,

        [Description("Prefer not to say")]
        PreferNotToSay = 98,

        [Description("Not provided")]
        NotProvided = 99
    }


    public enum LearningDifficultyOrDisabilityDeclaration
    {
        [Description("Customer considers themselves to have a learning difficulty and/or health problem")]
        CustomerConsidersThemselvesToHaveALearningDifficultyAndOrHealthProblem = 1,

        [Description("Customer does not consider themselves to have a learning difficulty and/or health problem")]
        CustomerDoesNotConsiderThemselvesToHaveALearningDifficultyAndOrHealthProblem = 2,

        [Description("Not provided by the customer")]
        NotProvidedByTheCustomer = 9
    }


    public class DiverstityDetails : AnonHelper, IAnonymise
    {
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public Guid? DiversityId { get; set; }
        public Guid? CustomerId { get; set; }
        public bool? ConsentToCollectLLDDHealth { get; set; }
        public LearningDifficultyOrDisabilityDeclaration? LearningDifficultyOrDisabilityDeclaration { get; set; }
        public PrimaryLearningDifficultyOrDisability? PrimaryLearningDifficultyOrDisability { get; set; }
        public SecondaryLearningDifficultyOrDisability? SecondaryLearningDifficultyOrDisability { get; set; }
        public DateTime? DateAndTimeLLDDHealthConsentCollected { get; set; }
        public bool? ConsentToCollectEthnicity { get; set; }
        public Ethnicity? Ethnicity { get; set; }
        public DateTime? DateAndTimeEthnicityCollected { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string LastModifiedBy { get; set; }

        public void Anonymise()
        {
            LearningDifficultyOrDisabilityDeclaration = RandomEnumValue<LearningDifficultyOrDisabilityDeclaration>();
            PrimaryLearningDifficultyOrDisability = RandomEnumValue<PrimaryLearningDifficultyOrDisability>();
            SecondaryLearningDifficultyOrDisability = RandomEnumValue<SecondaryLearningDifficultyOrDisability>();
            Ethnicity = RandomEnumValue<Ethnicity>();
        }
    }
}
